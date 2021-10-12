//
//  HomeViewController.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var articleList: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension

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

// MARK: - TableView Datasource -
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articleList.count
//        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ArticleCell.self)", for: indexPath) as? ArticleCell else {
            fatalError()
        }
            
//        let article = articleList[indexPath.row]
        
//        cell.setupCell(title: article.title, authorName: article.author.name, category: article.category, time: article.createdTime.description)
        
        cell.layoutIfNeeded()
        
        return cell
        
    }
}

// MARK: - TableView Delegate -
extension HomeViewController: UITableViewDelegate {
    
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
