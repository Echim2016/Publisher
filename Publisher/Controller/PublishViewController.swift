//
//  PublishViewController.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import UIKit
import Firebase

class PublishViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
            titleTextField.accessibilityLabel = "title"
        }
    }
    
    @IBOutlet weak var categoryTextField: UITextField! {
        didSet {
            categoryTextField.delegate = self
            categoryTextField.accessibilityLabel = "category"
        }
    }
    
    @IBOutlet weak var contentTextField: UITextField! {
        didSet {
            contentTextField.delegate = self
            contentTextField.accessibilityLabel = "content"
        }
    }
    
    var articleToPublish = Article.init(id: "", title: "", author: Author(id: "echim2016", name: "echim", email: "yyyyy@gmail.com"), category: "", content: "", createdTime: nil)
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pressPublish(_ sender: Any) {
        
        textFieldDidEndEditing(titleTextField)
        textFieldDidEndEditing(categoryTextField)
        textFieldDidEndEditing(contentTextField)
        setArticle(articleToPublish)
    }
    
}

// MARK: - Publish Action -
extension PublishViewController {
    
    func setArticle(_ article: Article) {
        
        let articles = db.collection("articles")
        let document = articles.document()
        let data: [String: Any] = [ "author": [
            "email": article.author.email,
            "id": article.author.id,
            "name": article.author.name
        ],
        "title": article.title,
        "content": article.content,
        "createdTime": NSDate().timeIntervalSince1970,
        "id": document.documentID,
        "category": article.category
        ]
        
        document.setData(data) { err in
            
            if let error = err {
                
                print("Error adding article \(error)")
            } else {
                
                print("Article added with ID: \(document.documentID)")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}

// MARK: - TextField -
extension PublishViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text,
              !text.isEmpty else {
            print("empty input")
            return
        }
        
        switch textField.accessibilityLabel {
        case "title":
            articleToPublish.title = text
        case "content":
            articleToPublish.content = text
        case "tag":
            articleToPublish.category = text
        default:
            break
        }
    }
}
