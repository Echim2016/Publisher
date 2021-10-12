//
//  HomeViewController.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var publishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        setupNavigationBar()
    }

    @IBAction func pressPublishButton(_ sender: Any) {
        
        performSegue(withIdentifier: "toPublishPage", sender: nil)
    }
    
}

// MARK: - View-related Setup -
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
    
    func setupView() {
        
        publishButton.layer.cornerRadius = publishButton.frame.width / 2
    }
    
    
}
