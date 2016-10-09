//
//  CircleView.swift
//  devslopes-social-app
//
//  Created by Steven Perkowski on 10/9/16.
//  Copyright © 2016 Steven Perkowski. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
}
