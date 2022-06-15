//
//  EventCollectionViewCell.swift
//  EventsManager
//
//  Created by Thiago Costa on 6/9/22.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "event-item-cell-reuse-identifier"
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var title: String? {
        didSet {
            configureUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
   

}

private extension EventCollectionViewCell {
    func configureUI() {
        guard let title = title else {
            return
        }
        dayOfTheWeekLabel.text = title
        dayOfTheWeekLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        containerView.layer.cornerRadius = 12
    }
}
