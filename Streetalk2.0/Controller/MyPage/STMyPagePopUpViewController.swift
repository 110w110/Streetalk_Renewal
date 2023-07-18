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
    var targetViewController: UIViewController?
    
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
            UserDefaults.standard.set(nil, forKey: "userToken")
            UserDefaults.standard.set(nil, forKey: "localPassword")
            self.dismiss(animated: true) {
                self.targetViewController?.dismiss(animated: true)
            }
        case .leave:
            leave()
            let notYet = UIAlertController(title: nil, message: "회원 탈퇴 준비 중입니다", preferredStyle: .alert)
            let okay = UIAlertAction(title: "확인", style: .default) { _ in self.targetViewController?.dismiss(animated: true) }
            notYet.addAction(okay)
            self.present(notYet, animated: true, completion: nil)
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
