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
    
    var popUpTitle: String = "title"
    var popUpContent: String = "content"
    var popUpUsage: PopUpViewUsage = .undefined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popUpView.setRoundedBorder(shadow: true)
        self.view.backgroundColor = .label.withAlphaComponent(0.2)

        self.titleLabel.text = popUpTitle
        self.contentsLabel.text = popUpContent
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        switch self.popUpUsage {
        case .logout:
            logOut()
        case .leave:
            leave()
        default:
            print("Error: pop-up usage is undefined")
        }
    }
    
}

extension STMyPagePopUpViewController {
    
    private func logOut() {
        print(#function)
    }
    
    private func leave() {
        print(#function)
    }
    
}

public enum PopUpViewUsage {
    case logout
    case leave
    case undefined
}
