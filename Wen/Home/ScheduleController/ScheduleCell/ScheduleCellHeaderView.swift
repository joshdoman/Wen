//
//  ScheduleCellHeaderView.swift
//  Wen
//
//  Created by Josh Doman on 4/5/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit

class ScheduleCellHeaderView: UITableViewHeaderFooterView {
    
    public var date: Date! {
        didSet {
            if Date.isToday(date: date) {
                header.text = "Your schedule today looks like"
            } else if Date.isTomorrow(date: date) {
                header.text = "Your schedule tomorrow looks like"
            } else if let day = date.dayOfWeek {
                header.text = "Your \(day) schedule looks like"
            }
        }
    }
    
    private let header: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: UIFont.lightFont, size: 20)
        label.textColor = UIColor.warmGrey
        label.backgroundColor = .white
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        addSubview(header)
        _ = header.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 28, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
