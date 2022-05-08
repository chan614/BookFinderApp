//
//  SearchedItemCell.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/06.
//

import UIKit

class SearchedItemCell: UITableViewCell {
    static let reuseID = "SearchedItemCell"
    
    @IBOutlet private weak var thumbnailView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
