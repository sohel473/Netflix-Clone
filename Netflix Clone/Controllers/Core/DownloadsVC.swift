//
//  DownloadsVC.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/2/22.
//

import UIKit

class DownloadsVC: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Downloads"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadTable)
        
        downloadTable.delegate = self
        downloadTable.dataSource = self
        
        fetchTitleFromDatabase()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchTitleFromDatabase()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    func fetchTitleFromDatabase() {
        DataPersistenceManager.shared.fetchingTitles { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.downloadTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
        guard let original_title = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name, let poster_path = titles[indexPath.row].poster_path else { return UITableViewCell() }
        cell.configure(with: TitleViewModel(title_name: original_title, poster_url: poster_path))
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

        APICaller.shared.getMovies(query: title_name + " trailer") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewViewModel(title: title_name, titleOverView: title_overview, youtubeOverview: videoElement))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitle(model: titles[indexPath.row]) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    print("Title Deleted Successfully")
                    
                case .failure(let error):
                    print(error)
                }
                self.titles.remove(at: indexPath.row)
                self.downloadTable.deleteRows(at: [indexPath], with: .left)
            }
        default:
            break
        }
    }
}
