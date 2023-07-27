//
//  STButton.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/13.
//

import UIKit

class STButton: UIButton {
    var gradient: CAGradientLayer?

    // override super initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // custom initializer
    convenience init(title: String) {
        self.init(frame: .zero)
    }
    
    // for using in storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        DispatchQueue.main.async {
            if self.isEnabled {
                self.setGradient(color1: UIColor.streetalkOrange, color2: UIColor.streetalkPink)
            } else {
                self.setGrayColor()
            }
            self.roundCorners(cornerRadius: 10)
            self.tintColor = .white
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    
    override var isEnabled:Bool {
        didSet {
            if isEnabled {
                self.setGradient(color1: UIColor.streetalkOrange, color2: UIColor.streetalkPink)
            } else {
                self.setGrayColor()
            }
        }
    }
    
    private func setGradient(color1:UIColor,color2:UIColor){
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
            self.gradient = nil
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        self.gradient = gradient
        layer.insertSublayer(gradient, at: 0)
    }
    
    private func setGrayColor() {
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
            self.gradient = nil
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.backgroundColor = UIColor.lightGray.cgColor
        gradient.frame = self.bounds
        self.gradient = gradient
        layer.insertSublayer(gradient, at: 0)
    }
    
    private func roundCorners(cornerRadius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
}
