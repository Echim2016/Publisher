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
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func setupCell(article: Article) {
        
        titleLabel.text = article.title
        authorLabel.text = article.author.name
        contentLabel.text = article.content
        categoryLabel.text = article.category
        categoryLabel?.layer.cornerRadius = 5
        categoryLabel?.layer.masksToBounds = true
        createdTimeLabel.text = article.createdTime.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss")
    }
    
}
