//
//  ResizableTextView.swift
//  TextViewKeyboardResize
//
//  Created by Ancil on 8/4/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

import UIKit

/*
        NOTE & ACKNOWLEDGEMENT
    This great and concise code is taken from GitHub Nikita2k/resizableTextView
    code, and converted by me into Swift
*/


class ResizableTextView: UITextView {

    override func updateConstraints() {
        //println("updateConstraints - Text")
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
        //println("layoutSubviews - Text")
        super.layoutSubviews()
    }
}
