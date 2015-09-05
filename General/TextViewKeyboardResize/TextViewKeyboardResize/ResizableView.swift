//
//  ResizableView.swift
//  TextViewKeyboardResize
//
//  Created by Ancil on 8/5/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

import UIKit

class ResizableView: UIView {

    override func updateConstraints() {
        //println("updateConstraints - View")
        var contentSize = sizeThatFits(CGSizeMake(frame.size.width, CGFloat.max))
        
        if let allConstraints = constraints() as? [NSLayoutConstraint] {
            for constraint in allConstraints {
                if constraint.firstAttribute == NSLayoutAttribute.Height {
                    constraint.constant = contentSize.height
                    break
                }
            }
        }
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        //println("layoutSubviews - View")
        super.layoutSubviews()
    }

}
