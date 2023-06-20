//
//  UIView+.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import UIKit

extension UIView {
    func setRoundedBorder(shadow: Bool = false) {
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.backgroundColor = .systemBackground
        
        if (shadow) {
            self.layer.shadowOffset = CGSize(width: 0, height: 10)
            self.layer.shadowOpacity = 0.15
            self.layer.shadowRadius = 15
        }
    }
}
