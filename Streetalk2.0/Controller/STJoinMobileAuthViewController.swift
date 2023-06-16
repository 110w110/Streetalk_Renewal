//
//  STJoinMobileAuthViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/16.
//

import UIKit

class STJoinMobileAuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mobileNumberTextField.delegate = self
        mobileNumberTextField.becomeFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // TODO: 번호 체크하는 로직 추가하기
        
        return true
    }
}
