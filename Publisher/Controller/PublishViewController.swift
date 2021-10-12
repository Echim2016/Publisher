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
    
    var article = Article.init(id: "", title: "", content: "", tag: "", author: "echim", createdTime: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pressPublish(_ sender: Any) {
        
        
    }
    
}

// MARK: - Publish Action -
extension PublishViewController {
    
    func publsihArticle() {
        
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
            article.title = text
        case "content":
            article.content = text
        case "tag":
            article.tag = text
        default:
            break
        }
    }
}
