//
//  SWPaddingableLabel.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/19.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

class SWPaddingableLabel: UILabel {

    let padding = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
