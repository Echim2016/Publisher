//
//  HomeViewController.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

}

extension HomeViewController {
    
    func setupNavigationBar() {
        
        let titleLabel = UILabel()
        titleLabel.text = "Publisher"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "PingFangTC-Semibold", size: 20)
        self.navigationItem.titleView = titleLabel
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.bluePurple
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    
}
