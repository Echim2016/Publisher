//
//  HomeViewController.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import UIKit
import Firebase

protocol PublishViewControllerDelegate: AnyObject {
    func dismissPublishView()
}

class HomeViewController: UIViewController {

    @IBOutlet weak var publishButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    private var publishVC: PublishViewController?
    
    let db = Firestore.firestore()
    
    var articleList: [Article] = []
    
    var publishViewIsShown: Bool = false {
        didSet {
            containerView.isHidden = !publishViewIsShown
            publishButton.isUserInteractionEnabled = !publishViewIsShown
            publishButton.alpha = publishViewIsShown ? 0.2 : 1
            tableView.isUserInteractionEnabled = !publishViewIsShown
            tableView.alpha = publishViewIsShown ? 0.2 : 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180

        print(self)
        fetchArticle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        setupNavigationBar()
    }

    @IBAction func pressPublishButton(_ sender: Any) {
        
        displayPublishView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPublishPage" {
            
            let destination = segue.destination as? PublishViewController
            destination?.delegate = self
        }
    }

}

// MARK: - TableView Datasource -
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articleList.count
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
            
        let article = articleList[indexPath.row]
        cell.setupCell(article: article)
        cell.layoutIfNeeded()
        
        return cell
        
    }
}

// MARK: - TableView Delegate -
extension HomeViewController: UITableViewDelegate {
    
}

// MARK: - Firebase Data -
extension HomeViewController {
    
    func fetchArticle() {
        
        db.collection("articles").order(by: "createdTime").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting article: \(err)")
            } else {
                
                self.articleList = []
                
                for document in querySnapshot!.documents {
                    
                    guard let id = document.get("id") as? String,
                          let title = document.get("title") as? String,
                          let category = document.get("category") as? String,
                          let author = document.get("author") as? [String:String],
                          let content = document.get("content") as? String,
                          let createdTime = document.get("createdTime") as? Double else {
                              print("article fetch failed")
                              return
                          }

                    guard let authorName = author["name"],
                          let authorEmail = author["email"],
                          let authorID = author["id"] else {
                              print("author fetch failed")
                              return
                          }
                    
                    let article = Article(
                        id: id,
                        title: title,
                        author: Author(id: authorID , name: authorName, email: authorEmail),
                        category: category,
                        content: content,
                        createdTime: NSDate(timeIntervalSince1970: TimeInterval(createdTime))
                    )
                    
                    self.articleList.append(article)
                    
                }
                print("-----Fetch end-----")
                self.tableView.reloadData()
            }
        }
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
        
        containerView.isHidden = true
        publishButton.layer.cornerRadius = publishButton.frame.width / 2
    }
    
    func displayPublishView() {
        
        publishViewIsShown = true
    }
    
}

// MARK: - Delegate -
extension HomeViewController: PublishViewControllerDelegate {
    
    func dismissPublishView() {
        
        self.publishViewIsShown = false
    }
}
