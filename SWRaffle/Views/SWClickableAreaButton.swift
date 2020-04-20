//
//  SWClickableAreaButton.swift
//  SWRaffle
//
//  Created by Jason on 2020/4/20.
//  Copyright © 2020 UTAS. All rights reserved.
//

import UIKit

class SWClickableAreaButton: UIButton {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin:CGFloat = -12
        let clickableArea = bounds.insetBy(dx: margin, dy: margin)
        return clickableArea.contains(point)
    }

}
