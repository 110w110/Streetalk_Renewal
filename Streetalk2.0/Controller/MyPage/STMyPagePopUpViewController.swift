//
//  STMyPagePopUpViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/23.
//

import UIKit

class STMyPagePopUpViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var popUpView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popUpView.setRoundedBorder(shadow: true)
        self.view.backgroundColor = .label.withAlphaComponent(0.5)

    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
    }
    
}
