//
//  RoundedButton.swift
//  DoloChallenge
//
//  Created by Kevin Langelier on 2/26/18.
//  Copyright © 2018 Kevin Langelier. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = bounds.height / 2
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 1.0
        backgroundColor = .clear
        clipsToBounds = true
        setTitleColor(tintColor, for: .normal)
    }

}
