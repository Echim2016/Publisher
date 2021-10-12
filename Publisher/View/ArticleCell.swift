//
//  ArticleCell.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func setupCell(article: Article) {
        
        titleLabel.text = article.title
        authorLabel.text = article.author.name
        contentLabel.text = article.content
        categoryButton.titleLabel?.text = article.category
        createdTimeLabel.text = article.createdTime.description
    }
    
}
