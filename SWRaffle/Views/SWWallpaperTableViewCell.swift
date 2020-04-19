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
    let priceLabel: SWPaddingableLabel! = SWPaddingableLabel.init()
    let stockLabel: SWPaddingableLabel! = SWPaddingableLabel.init()
    let wallpaperView: UIImageView! = UIImageView.init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                 
        self.selectionStyle = .none
        
        wallpaperView.contentMode = .scaleAspectFill
        wallpaperView.clipsToBounds = true
        wallpaperView.layer.cornerRadius = 10
        
        wallpaperView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.layer.cornerRadius = 5
        priceLabel.layer.cornerRadius = 5
        stockLabel.layer.cornerRadius = 5
        
        nameLabel.layer.backgroundColor = UIColor.white.cgColor
        priceLabel.layer.backgroundColor = UIColor.white.cgColor
        stockLabel.layer.backgroundColor = UIColor.white.cgColor
        
        nameLabel.textColor = UIColor.orange
        priceLabel.textColor = UIColor.orange
        stockLabel.textColor = UIColor.orange
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        priceLabel.font = UIFont.boldSystemFont(ofSize: 15)
        stockLabel.font = UIFont.systemFont(ofSize: 15)

        nameLabel.textAlignment = .center
        priceLabel.textAlignment = .center
        stockLabel.textAlignment = .right

        contentView.addSubview(wallpaperView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
        
        // layout Views
        let layoutViews:[String: UIView] = ["contentView": contentView, "wallpaperView": wallpaperView, "nameLabel": nameLabel, "priceLabel": priceLabel, "stockLabel": stockLabel]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-12-[wallpaperView]-12-|", options:[], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[contentView]-(<=0)-[nameLabel]", options:[.alignAllCenterX], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:|-24-[priceLabel]", options:[], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[stockLabel]-24-|", options:[], metrics:nil, views:layoutViews))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:|-0-[wallpaperView]-0-|", options:[], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[contentView]-(<=0)-[nameLabel]", options:[.alignAllCenterY], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"H:[contentView]-(<=0)-[priceLabel]", options:[.alignAllCenterY], metrics:nil, views:layoutViews))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:"V:[stockLabel]-12-|", options:[], metrics:nil, views:layoutViews))
        
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
