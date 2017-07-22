//
//  RoundedButton.swift
//  SocialApp
//
//  Created by Gabriel Trujillo Gómez on 7/15/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib()
    {
        layer.shadowColor = UIColor(displayP3Red: 120 / 255, green: 120 / 255, blue: 120 / 255, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 0.5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 5.0
    }

}
