//
//  SWTitleView.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/18.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

class SWTitleView: UIView {
    
    let titleLabel: UILabel! = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        titleLabel.textColor = UIColor.gray
        addSubview(titleLabel)
        
        // layout Views
        let layoutViews:[String: UILabel] = ["titleLabel": titleLabel]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-15-[titleLabel]-15-|", options:[], metrics:nil, views:layoutViews))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[titleLabel]-0-|", options:[], metrics:nil, views:layoutViews))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
