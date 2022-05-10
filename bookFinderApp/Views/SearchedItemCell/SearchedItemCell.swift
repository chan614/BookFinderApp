//
//  SearchedItemCell.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/06.
//

import UIKit
import Kingfisher

class SearchedItemCell: UITableViewCell {
    static let reuseID = "SearchedItemCell"
    
    @IBOutlet private weak var thumbnailView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(item: BookListItem) {
        titleLabel.text = item.title
        authorLabel.text = item.author
        dateLabel.text = item.date
        thumbnailView.kf.setImage(with: item.thumbnailURL)
    }
}
