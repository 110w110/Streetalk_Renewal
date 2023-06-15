//
//  STWriteViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STWriteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        lazy var rightButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(writeButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func writeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
