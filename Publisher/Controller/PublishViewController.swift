//
//  PublishViewController.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import UIKit
import Firebase

class PublishViewController: UIViewController {

    weak var delegate: PublishViewControllerDelegate?
    
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
            categoryTextField.text = Category.beauty.title
        }
    }
    
    @IBOutlet weak var contentTextField: UITextField! {
        didSet {
            contentTextField.delegate = self
            contentTextField.accessibilityLabel = "content"
        }
    }
    
    @IBOutlet var texfields: [UITextField]!
    
    var articleToPublish = Article.init(id: "", title: "", author: Author(id: "", name: "", email: ""), category: "", content: "", createdTime: Date())
    
    let db = Firestore.firestore()
    
    let pickerView = UIPickerView()
    
    var pickerSelectedIndex = 0
    
    let currentText = Category.beauty.title
    
    var authorInfo = Author(id: "echim2016", name: "Yi-Chin Hsu", email: "ych@gmail.com")
//    var authorInfo = Author(id: "", name: "", email: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    @IBAction func pressPublish(_ sender: Any) {
        
        textFieldDidEndEditing(titleTextField)
        textFieldDidEndEditing(categoryTextField)
        textFieldDidEndEditing(contentTextField)
    
        articleToPublish.author = authorInfo
        setArticle(articleToPublish)
    }
    
}

// MARK: - Publish Action -
extension PublishViewController {
    
    func setArticle(_ article: Article) {
        
        let articles = db.collection("articles")
        let document = articles.document()
        
        
        guard !article.author.email.isEmpty,
              !article.author.id.isEmpty,
              !article.author.name.isEmpty else {
                  
                  showAlert(alertText: "Oops!", alertMessage: "Author info not found")
                  return
              }
        
        let data: [String: Any] = [ "author": [
            "email": article.author.email,
            "id": article.author.id,
            "name": article.author.name
        ],
        "title": article.title,
        "content": article.content,
        "createdTime": Date().timeIntervalSince1970,
        "id": document.documentID,
        "category": article.category
        ]
        
        document.setData(data) { err in
            
            if let error = err {
                
                print("Error adding article \(error)")
            } else {
                
                print("Article added with ID: \(document.documentID)")
                self.delegate?.dismissPublishView()
                self.texfields.forEach { $0.text = "" }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityLabel == "category" {
            self.initPickerView(touchAt: textField)
        }
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
        case "category":
            articleToPublish.category = text
        default:
            break
        }
    }
    
    func initPickerView(touchAt sender: UITextField){
        
        let currentText = categoryTextField.text
        pickerSelectedIndex = Category.allCases.filter{$0.title == currentText}.first?.rawValue ?? 0
        pickerView.selectRow(pickerSelectedIndex, inComponent: 0, animated: true)
        
        categoryTextField.inputView = pickerView
        categoryTextField.becomeFirstResponder()
    }
}

// MARK: - PickerView -
extension PublishViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Category.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Category.allCases[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryTextField.text = Category.allCases[row].title
        self.view.endEditing(true)
    }
    
}

