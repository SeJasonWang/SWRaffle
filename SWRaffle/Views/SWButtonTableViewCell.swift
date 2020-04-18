//
//  SWButtonTableViewCell.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/18.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

class SWButtonTableViewCell: UITableViewCell {

    let label: UILabel! = UILabel.init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        self.contentView.addSubview(label)
        
        label.textAlignment = .center
        label.textColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = self.bounds
        label.frame.origin.x += 15
        label.frame.origin.y += 5
        label.frame.size.width -= 30
        label.frame.size.height -= 10
    }

}
