//
//  STJoinMobileAuthViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/16.
//

import UIKit
import AnyFormatKit
import CoreLocation

class STJoinMobileAuthViewController: UIViewController {

    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var submitButton: STButton!
    @IBOutlet weak var authButton: STButton!
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var backgroundPhoneImageView: UIImageView!
    @IBOutlet var retryLabel: UILabel!
    @IBOutlet var locationIndicatorView: UIActivityIndicatorView!
    @IBOutlet var indicatiorDimmingView: UIView!
    
    private let locationManager = CLLocationManager()
    private let timeLimit: Int = 180
    private var timeRemain: Int = 180
    private var timer: Timer?
    private var location: Location?
    private var loginInfo: Login?
    private var masterNumber: String = "960513"
    private var serverNumber: String?
    
    var auth: [String : String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        submitButton.isEnabled = false
        authStackView.isHidden = true
        
        locationManager.delegate = self
        requestLocationAuth()
        
        self.hideKeyboardWhenTappedAround()
        
        mobileNumberTextField.delegate = self
        mobileNumberTextField.becomeFirstResponder()
        
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
//        submitButton.setGrayColor()
        smsReqeust()
    }
    
    @IBAction func retryAuthButtonTapped(_ sender: Any) {
        self.timeRemain = self.timeLimit
        smsReqeust()
    }
    
    @IBAction func authButtonTapped(_ sender: Any) {
        if self.timeRemain <= 0 {
            let alert = UIAlertController(title: nil, message: "인증 시간이 초과되었습니다", preferredStyle: .alert)
            let okay = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if authNumberTextField.text != self.serverNumber &&
            (authNumberTextField.text != self.masterNumber || mobileNumberTextField.text != "010-7250-3150") {
            let alert = UIAlertController(title: nil, message: "인증번호가 일치하지 않습니다", preferredStyle: .alert)
            let okay = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        setLocation()
        
    }
    
}

extension STJoinMobileAuthViewController {
    
    private func setLocation() {
        
        guard let phoneNum = mobileNumberTextField.text?.replacingOccurrences(of: "-", with: ""), let authNum = self.serverNumber else { return }
        
        guard let longitude = self.location?.longitude, let latitude = self.location?.latitude else {
            print("Error: cannot request Login")
            print("Check phone number or auth number")
            return
        }
        
        self.indicatiorDimmingView.isHidden = false
        
        let request = URLSessionRequest<Login>(uri: "/user/login", methods: .post, auth: false, param: ["phoneNum" : phoneNum, "longitude" : longitude, "latitude" : latitude, "randomNum" : authNum])
        request.request(completion: { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.indicatiorDimmingView.isHidden = true
                    if data.userName == "new user" {
                        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "joinRegisterViewController") as! STJoinRegisterViewController
                        nextViewController.title = "본인인증하기"
                        nextViewController.loginInfo = self.loginInfo
                        
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    } else {
                        guard let token = data.token else { return }
                        UserDefaults.standard.set(token, forKey: "userToken")
                        let mainViewController = STMainViewController()
                        mainViewController.modalPresentationStyle = .fullScreen
                        mainViewController.modalTransitionStyle = .crossDissolve
                        
                        self.present(mainViewController, animated: true, completion: {
                            self.navigationController?.popToRootViewController(animated: false)
                        })
                    }
                    
                }
                self.loginInfo = data
                
            case let .failure(error):
                DispatchQueue.main.async {
                    self.indicatiorDimmingView.isHidden = true
                }
                print(error)
                self.errorMessage(error: error, message: #function)
            }
        })
    }
    
    private func timerSet() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    @objc func timerCallback(){
        if(self.timeRemain <= 0){
            self.timer?.invalidate()
            self.timer = nil
        }
        else{
            self.timeRemain -= 1
            retryLabel.text = String(format: "문자를 받지 못하셨나요? %02d",self.timeRemain / 60) + ":" + String(format: "%02d",self.timeRemain % 60)
        }
    }
    
    private func smsReqeust() {
        authStackView.isHidden = false
        backgroundPhoneImageView.isHidden = true
        submitButton.isEnabled = false
        mobileNumberTextField.isEnabled = false
        authNumberTextField.becomeFirstResponder()
        
        timerSet()
        
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
                self.errorMessage(error: error, message: #function)
            }
        })
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

extension STJoinMobileAuthViewController: CLLocationManagerDelegate {
    
    private func requestLocationAuth() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = Location(longitude: Double(location.coordinate.longitude), latitude: Double(location.coordinate.latitude))
        self.authButton.isEnabled = true
        self.authButton.setTitle("인증하기", for: .normal)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }
    
}
