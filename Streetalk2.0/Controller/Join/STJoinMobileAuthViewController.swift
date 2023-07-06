//
//  STJoinMobileAuthViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/16.
//

import UIKit
import AnyFormatKit

class STJoinMobileAuthViewController: UIViewController {

    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var submitButton: STButton!
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var backgroundPhoneImageView: UIImageView!
    
    private var masterNumber: String = "960513"
    private var serverNumber: String?
    
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
        
        // 인증번호 요청
        guard let mobileNum = mobileNumberTextField.text?.replacingOccurrences(of: "-", with: "") else { return }
        let registerRequest = RegisterRequest(param: ["phoneNum" : mobileNum])
        registerRequest.request(completion: { result in
            switch result {
            case let .success(data):
                guard let randomNum = data.randomNum else {
                    print("Error: random number is nil")
                    return
                }
                print(randomNum)
                self.serverNumber = randomNum
            case let .failure(error):
                print(error)
            }
        })
        
    }
    
    @IBAction func authButtonTapped(_ sender: Any) {
        if authNumberTextField.text != self.serverNumber && authNumberTextField.text != self.masterNumber {
            return
        }
        
        guard let mobileNum = mobileNumberTextField.text?.replacingOccurrences(of: "-", with: ""), let serverNumber = self.serverNumber else { return }
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "joinRegisterViewController") as! STJoinRegisterViewController
        nextViewController.title = "본인인증하기"
        nextViewController.auth = ["phoneNum" : mobileNum, "authNum" : serverNumber]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}

extension STJoinMobileAuthViewController:  UITextFieldDelegate {
    
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
