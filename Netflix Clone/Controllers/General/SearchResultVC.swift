//
//  SearchResultVC.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/13/22.
//

import UIKit

protocol SearchResultVCDelegate: AnyObject {
    func SearchResultVCdidTap(_ viewModel: TitlePreviewViewModel)
}

class SearchResultVC: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    weak var delegate: SearchResultVCDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(searchResultCollectionView)
        
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
}

extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
        if let poster_path = titles[indexPath.row].poster_path {
            cell.configure(with: poster_path)
        }
        //        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let title_name = title.original_title ?? title.original_name, let title_overview = title.overview else { return }
        
        APICaller.shared.getMovies(query: title_name + " trailer") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let videoElement):
                self.delegate?.SearchResultVCdidTap(TitlePreviewViewModel(title: title_name, titleOverView: title_overview, youtubeOverview: videoElement))
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
}
