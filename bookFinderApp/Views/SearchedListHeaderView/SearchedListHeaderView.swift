//
//  SearchedListHeaderView.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/09.
//

import UIKit

class SearchedListHeaderView: UIView {
    
    
    private let titleView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setUp() {
        addSubview(titleView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        backgroundColor = .lightGray
    }
    
    func configure(totalCount: Int) {
        titleView.text = "Results (\(totalCount))"
    }
}
