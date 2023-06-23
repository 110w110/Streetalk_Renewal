//
//  UIView+.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import UIKit

extension UIView {
    func setRoundedBorder(shadow: Bool = false, bottomExtend: Bool = false) {
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.backgroundColor = .systemBackground
        self.clipsToBounds = true
        
        if (shadow) {
            self.layer.shadowOffset = CGSize(width: 0, height: 10)
            self.layer.shadowOpacity = 0.15
            self.layer.shadowRadius = 15
        }
        
        if bottomExtend {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.layer.addBorder([.top, .left, .right], color: .systemGray5, width: 1)
        }
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
