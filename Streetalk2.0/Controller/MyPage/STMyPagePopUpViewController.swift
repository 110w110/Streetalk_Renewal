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
    @IBOutlet var confirmButton: STButton!
    
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
        case .leave:
            leave()
        default:
            print("Error: pop-up usage is undefined")
        }
    }
    
}

extension STMyPagePopUpViewController {
    
    private func logOut() {
        DispatchQueue.main.async {
            UserDefaults.standard.set(nil, forKey: "userToken")
            UserDefaults.standard.set(nil, forKey: "localPassword")
            self.dismiss(animated: true) {
                self.targetViewController?.dismiss(animated: true)
            }
        }
    }
    
    private func leave() {
        let request = LeaveReqeust()
        request.request(completion: { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    UserDefaults.standard.set(nil, forKey: "userToken")
                    UserDefaults.standard.set(nil, forKey: "localPassword")
                    self.dismiss(animated: true) {
                        self.targetViewController?.dismiss(animated: true)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    let notYet = UIAlertController(title: nil, message: "정상적으로 처리되지 않았습니다", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "확인", style: .default) { _ in self.targetViewController?.dismiss(animated: true) }
                    notYet.addAction(okay)
                    self.present(notYet, animated: true, completion: nil)
                }
            }
        })
        
    }
    
}

public enum PopUpViewUsage {
    case logout
    case leave
    case undefined
}
