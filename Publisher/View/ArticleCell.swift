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
    
    func setupCell(title: String, authorName: String, category: String, time: String) {
        
        titleLabel.text = "IU「亂穿」竟美出新境界!笑稱自己品味奇怪 網笑:靠顏值撐住女神氣場"
        
        authorLabel.text = "echim"
        
        contentLabel.text = "Every UIView with enabled Auto Layout passes 3 steps after initialization: update, layout and ender. These steps do not occur in a one-way direction. It’s possible for a step to trigger any previous one or even orce the whole cycle to repeat."
        
        categoryButton.titleLabel?.text = "Beauty"
        
        createdTimeLabel.text = NSDate().description
        
    }
    
    
}
