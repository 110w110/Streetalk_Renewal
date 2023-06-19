//
//  STJoinMobileAuthViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/16.
//

import UIKit
import AnyFormatKit

class STJoinMobileAuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var submitButton: STButton!
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var backgroundPhoneImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        submitButton.isEnabled = false
        authStackView.isHidden = true

        mobileNumberTextField.delegate = self
        mobileNumberTextField.becomeFirstResponder()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        authStackView.isHidden = false
        backgroundPhoneImageView.isHidden = true
        submitButton.isEnabled = false
        mobileNumberTextField.isEnabled = false
        authNumberTextField.becomeFirstResponder()
    }
    
    @IBAction func authButtonTapped(_ sender: Any) {
        // TODO: 인증번호에 따라서 넘어갈 수 있도록 변경하기
        if authNumberTextField.text != "000000" {
            return
        }
        
        // next viewcontroller
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "joinRegisterViewController") as! STJoinRegisterViewController
        nextViewController.title = "본인인증하기"
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 번호 입력에 따라 실시간으로 포맷팅
        guard let text = textField.text else {
            return false
        }
        let characterSet = CharacterSet(charactersIn: string)
        if CharacterSet.decimalDigits.isSuperset(of: characterSet) == false {
            return false
        }

        let formatter = DefaultTextInputFormatter(textPattern: "###-####-####")
        let result = formatter.formatInput(currentText: text, range: range, replacementString: string)
        textField.text = result.formattedText
        let position = textField.position(from: textField.beginningOfDocument, offset: result.caretBeginOffset)!
        textField.selectedTextRange = textField.textRange(from: position, to: position)
        
        // 유효한 번호가 입력되었을 때 버튼이 활성화됨
        if let string = textField.text {
            submitButton.isEnabled = string.isValidPhoneNum()
        }
        
        return false
    }
}
