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

    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.delegate = self
            contentTextView.text = "content"
            contentTextView.textColor = .systemGray3
            contentTextView.layer.cornerRadius = 5
            contentTextView.layer.borderWidth = 0.7
            contentTextView.layer.borderColor = UIColor.systemGray5.cgColor
        }
    }
    
    var articleToPublish = Article.init(id: "", title: "", author: Author(id: "", name: "", email: ""), category: Category.beauty.title, content: "", createdTime: Date())
    let db = Firestore.firestore()
    let pickerView = UIPickerView()
    var pickerSelectedIndex = 0
    
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
        textViewDidEndEditing(contentTextView)
        
        if articleToPublish.title == "" ||
           articleToPublish.content == "content" ||
           articleToPublish.content == "" {
            
            showAlert(alertText: "Oops!", alertMessage: "Please fill out all the fields.")
            
        } else {
            
            articleToPublish.author = authorInfo
            setArticle(articleToPublish)
        }
        
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
                self.resetUserInput()
            }
        }
    }
    
    func resetUserInput() {
        
        titleTextField.text = ""
        categoryTextField.text = Category.beauty.title
        contentTextView.text = ""
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
        default:
            break
        }
    }
    
    func initPickerView(touchAt sender: UITextField) {
        
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
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Category.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Category.allCases[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryTextField.text = Category.allCases[row].title
        articleToPublish.category = Category.allCases[row].title
        self.view.endEditing(true)
    }
    
}

// MARK: - TextView -
extension PublishViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let text = textView.text,
              !text.isEmpty else {
                  print("empty input")
                  textView.text = "content"
                  textView.textColor = UIColor.systemGray3
                  return
              }
        
        articleToPublish.content = textView.text
    }
    
}
