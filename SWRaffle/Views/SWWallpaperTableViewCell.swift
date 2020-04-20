//
//  SWWallpaperTableViewCell.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/18.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

class SWWallpaperTableViewCell: UITableViewCell {

    var didDrawDashdeline = false
    let nameLabel: SWPaddingableLabel! = SWPaddingableLabel.init()
    let descriptionLabel: SWPaddingableLabel! = SWPaddingableLabel.init()
    let priceLabel: SWPaddingableLabel! = SWPaddingableLabel.init()
    let stockLabel: SWPaddingableLabel! = SWPaddingableLabel.init()
    let wallpaperView: UIImageView! = UIImageView.init()

    // only for Home page
    let editButton: UIButton! = SWClickableAreaButton.init(type: .custom)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                 
        wallpaperView.backgroundColor = UIColor.lightGray
        selectionStyle = .none
        
        wallpaperView.contentMode = .scaleAspectFill
        wallpaperView.clipsToBounds = true
        wallpaperView.layer.cornerRadius = 10
        descriptionLabel.numberOfLines = 1
        editButton.setTitle("Edit", for: .normal)
        editButton.backgroundColor = UIColor.orange
        editButton.setTitleColor(UIColor.white, for: .normal)
        editButton.layer.cornerRadius = 5
        
        wallpaperView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.font = UIFont.boldSystemFont(ofSize: 16)
        stockLabel.font = UIFont.systemFont(ofSize: 14)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        nameLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        stockLabel.textAlignment = .right

        contentView.addSubview(wallpaperView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(editButton)

        // layout Views
        let layoutViews:[String: UIView] = ["contentView": contentView, "wallpaperView": wallpaperView, "nameLabel": nameLabel, "descriptionLabel": descriptionLabel, "priceLabel": priceLabel, "stockLabel": stockLabel, "editButton": editButton]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-12-[wallpaperView]-12-|", options:[], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[contentView]-(<=0)-[nameLabel]", options:[.alignAllCenterY], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[descriptionLabel]", options:[], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[stockLabel]-24-|", options:[], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[editButton(==44)]-24-|", options:[], metrics:nil, views:layoutViews))

        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[wallpaperView]-0-|", options:[], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[contentView]-(<=0)-[nameLabel]", options:[.alignAllCenterX], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[nameLabel]-6-[descriptionLabel]", options:[.alignAllCenterX], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[stockLabel]-12-|", options:[], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|-12-[editButton]", options:[], metrics:nil, views:layoutViews))

    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.size.height -= 12
            super.frame = newFrame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if wallpaperView.bounds.width > 0 && didDrawDashdeline == false {
            addDashdeBorderLayer(wallpaperView, UIColor.white, 1)
            didDrawDashdeline = true
        }
        
        // Layout priceLabel
        let maximumWidth = wallpaperView.bounds.width / 5 - 4
        if priceLabel.intrinsicContentSize.width > maximumWidth {
            priceLabel.frame.size = CGSize.init(width: maximumWidth, height: priceLabel.intrinsicContentSize.height)
        } else {
            priceLabel.frame.size = priceLabel.intrinsicContentSize
        }
        
        priceLabel.center.x = (wallpaperView.bounds.width / 5 / 2) + 12
        priceLabel.center.y = wallpaperView.center.y

    }
    
    func addDashdeBorderLayer(_ view:UIView, _ color:UIColor, _ width:CGFloat) {
        let shapeLayer = CAShapeLayer()
        let size = view.frame.size
        
        let shapeRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [3, 4]
    
        let path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10)
        path.move(to: CGPoint(x: size.width / 5, y: 0))
        path.addLine(to: CGPoint(x: size.width / 5, y: UIScreen.main.bounds.size.width / 2.5))

        shapeLayer.path = path.cgPath
        
        view.layer.addSublayer(shapeLayer)
    }

}
