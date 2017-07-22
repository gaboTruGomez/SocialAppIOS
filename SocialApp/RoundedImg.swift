//
//  RoundedImg.swift
//  SocialApp
//
//  Created by Gabriel Trujillo Gómez on 7/17/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import UIKit

class RoundedImg: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
    }
}
