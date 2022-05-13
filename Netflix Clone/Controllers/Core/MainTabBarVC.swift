//
//  MainTabBarVC.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/2/22.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let upcomingVC = UINavigationController(rootViewController: UpcomingVC())
        let searchVC = UINavigationController(rootViewController: SearchVC())
        let downloadsVC = UINavigationController(rootViewController: DownloadsVC())
        
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        
        upcomingVC.tabBarItem.title = "Upcoming"
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        
        searchVC.tabBarItem.title = "Search"
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        downloadsVC.tabBarItem.title = "Downloads"
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down")
        
        tabBar.tintColor = .label
        
        
        setViewControllers([homeVC, upcomingVC, searchVC, downloadsVC], animated: true)
    }

}
