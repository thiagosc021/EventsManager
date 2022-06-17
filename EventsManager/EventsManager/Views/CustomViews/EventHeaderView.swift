//
//  EventHeaderView.swift
//  EventsManager
//
//  Created by Thiago Costa on 6/9/22.
//

import UIKit

class EventHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "header-reuse-identifier"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

private extension EventHeaderView {
    func configureUI() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 10.0, paddingBottom: 0, paddingLeft: 10.0, paddingRight: 0)
        label.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}
