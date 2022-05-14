//
//  SearchVC.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/2/22.
//

import UIKit

class SearchVC: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultVC())
        search.searchBar.placeholder = "Search for a Movie or a TV Show"
        search.searchBar.searchBarStyle = .minimal
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        view.addSubview(discoverTable)
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


//MARK: - UICollectionView Delegate and Datasource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
        
        guard let original_title = titles[indexPath.row].original_title, let poster_path = titles[indexPath.row].poster_path else { return UITableViewCell() }
        let model = TitleViewModel(title_name: original_title, poster_url: poster_path)
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let title_name = title.original_name ?? title.original_title, let title_overview = title.overview
        else {
            return
        }
//        print("IN")
        APICaller.shared.getMovies(query: title_name + " trailer") { [weak self] result in
            guard let self = self else { return }
//            print("ININ")
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
//                    print("INININ")
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewViewModel(title: title_name, titleOverView: title_overview, youtubeOverview: videoElement))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

//MARK: - UISearchController Updater
extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
        let resultController = searchController.searchResultsController as? SearchResultVC else { return }
        resultController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }

}

extension SearchVC: SearchResultVCDelegate {
    
    func SearchResultVCdidTap(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
