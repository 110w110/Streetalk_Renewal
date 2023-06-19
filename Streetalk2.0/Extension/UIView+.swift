//
//  UIView+.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import UIKit

extension UIView {
    func setRoundedBorder() {
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
    }
}
