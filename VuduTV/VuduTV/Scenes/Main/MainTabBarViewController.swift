//
//  ViewController.swift
//  VuduTV
//
//  Created by Mcbook Pro on 01.09.22.
//

import UIKit

class MainTabBarViewController: UITabBarController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house" )
        vc2.tabBarItem.image = UIImage(systemName: "play.circle" )
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass" )
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down" )
        
        vc1.title = "Home"
        vc2.title = "Comming Soon"
        vc3.title = "Top"
        vc4.title = "Downloads"
        
    
        tabBar.tintColor = .yellow
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)

    }
    
    
}

