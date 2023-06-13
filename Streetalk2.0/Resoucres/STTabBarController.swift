//
//  STTabBarController.swift
//  Streetalk2.0
//
//  Created by 한태희 [hantae] on 2023/03/31.
//

import UIKit

class STTabBarController: UITabBarController {

    public var addButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMiddleButton()
    }
    

    //코드로 탭바 가운데 버튼 넣기
    func setupMiddleButton(){
        addButton.backgroundColor = .clear
        addButton.setImage(UIImage(named: "Write"), for: UIControl.State.normal)
        
        addButton.backgroundColor = UIColor.clear
        addButton.layer.cornerRadius = 24
        
        addButton.contentMode = .scaleToFill
        addButton.addTarget(self, action: #selector(self.addButtonAction(sender:)), for: UIControl.Event.touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addButton)
        
        NSLayoutConstraint(item: addButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 36).isActive = true
        
        self.view.layoutIfNeeded()
    }

    @objc func addButtonAction(sender: UIButton) {
        print("check")
    }
}
