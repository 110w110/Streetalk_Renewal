//
//  STJoinRegisterViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import UIKit
import CoreLocation

class STJoinRegisterViewController: UIViewController {
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var nicknameSectionView: UIView!
    @IBOutlet var locationSectionView: UIView!
    @IBOutlet var jobSectionView: UIView!
    @IBOutlet var locationCollectionView: UICollectionView!
    @IBOutlet var jobCollectionView: UICollectionView!
    @IBOutlet var isValidNickNameLabel: UILabel!
    @IBOutlet var isValidCharLabel: UILabel!
    @IBOutlet var lengthLimitLabel: UILabel!
    @IBOutlet var confirmButton: STButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var locationIndicator: UIActivityIndicatorView!
    
    private let locationManager = CLLocationManager()
    private var location: Location?
    
    private var nearCities: [Cities] = []
    private var industries: [String] = []
    private var selectedIndustry: String?
    private let industryList: [String] = ["식당", "카페", "주점", "오락", "미용", "숙박", "교육", "스포츠", "반려동물", "제조 및 유통", "의료", "패션"]
    
    var loginInfo: Login?
    var isFirstRegister: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        nickNameTextField.becomeFirstResponder()
        scrollView.keyboardDismissMode = .onDrag
        
        selectedIndustry = industryList[0]
        
        nicknameSectionView.setRoundedBorder()
        locationSectionView.setRoundedBorder()
        jobSectionView.setRoundedBorder()
        jobCollectionView.setRoundedBorder()
        
        locationManager.delegate = self
        requestLocationAuth()
        
        nickNameTextField.delegate = self
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        
        locationCollectionView.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            return layout
        }()
        
        jobCollectionView.delegate = self
        jobCollectionView.dataSource = self
        
        jobCollectionView.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            return layout
        }()
        
        guard let text = nickNameTextField.text else { return }
        setNickNameCheckUI(nickname: text)
        
        self.nearCities = loginInfo?.nearCities ?? []
        self.nearCities.insert(Cities(fullName: loginInfo?.currentCity, id: nil), at: 0)
        
        fetchProfile()
    }
    
    @IBAction func nickNameTextFieldEditing(_ sender: Any) {
        guard let text = nickNameTextField.text else { return  }
        setNickNameCheckUI(nickname: text)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "가입하시겠습니까?", message: "닉네임 : \(self.nickNameTextField.text ?? "")\n지역 : \(self.locationTextField.text ?? "")\n업종 : \(self.selectedIndustry ?? "")\n가입 이후에도 변경 가능합니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "가입", style: .default) { action in
            self.showHomeViewController()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
}

extension STJoinRegisterViewController {
    private func fetchProfile() {
        guard let token = UserDefaults.standard.string(forKey: "userToken"), token != "" else { return }
        guard let latitude = location?.latitude, let longitude = location?.longitude else { return }
        let request = GetProfileRequest(param: ["latitude" : latitude, "longitude" : longitude])
        request.request(completion: { result in
            switch result {
            case let .success(data):
                self.nickNameTextField.text = data.userName ?? ""
                self.selectedIndustry = data.industry ?? "식당"
                self.nearCities += data.nearCities ?? []
                if let currentCity = data.currentCity {
                    self.nearCities.insert(Cities(fullName: currentCity, id: 0), at: 0)
                }
                
                DispatchQueue.main.async {
                    self.jobCollectionView.reloadData()
                    self.locationCollectionView.reloadData()
                    self.locationIndicator.isHidden = true
                }
            case let .failure(error):
                print(error)
                DispatchQueue.main.async {
                    self.locationIndicator.isHidden = true
                }
            }
        })
    }
    
    private func showHomeViewController() {
        guard let name = self.nickNameTextField.text, let location = self.locationTextField.text, let industry = self.selectedIndustry else { return }
        let request = JoinRequest(param: ["name" : name, "location" : location, "industry" : industry])
        guard let token = loginInfo?.token else { return }
        UserDefaults.standard.set(token, forKey: "userToken")
        request.request(completion: { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let mainViewController = STMainViewController()
                    mainViewController.modalPresentationStyle = .fullScreen
                    mainViewController.modalTransitionStyle = .crossDissolve
                    self.present(mainViewController, animated: true, completion: {
                        self.navigationController?.popToRootViewController(animated: false)
                    })
                }
            case .failure(_):
                UserDefaults.standard.set(nil, forKey: "userToken")
            }
        })
    }
    
    private func setNickNameCheckUI(nickname: String) {
        if nickname.isValidChar() {
            isValidCharLabel.textColor = .systemGreen
        } else {
            isValidCharLabel.textColor = .streetalkPink
        }
        
        if nickname.isConformLengthLimit() {
            lengthLimitLabel.textColor = .systemGreen
        } else {
            lengthLimitLabel.textColor = .streetalkPink
        }
        
        if nickname.isValidChar() && nickname.isConformLengthLimit() {
            isValidNickNameLabel.textColor = .systemGreen
            confirmButton.isEnabled = true
            
        } else {
            isValidNickNameLabel.textColor = .streetalkPink
            confirmButton.isEnabled = false
        }
    }
    
}

extension STJoinRegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
}

extension STJoinRegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == locationCollectionView {
            return nearCities.count
        }
        else if collectionView == jobCollectionView {
            return industryList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == locationCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as? STRegisterLocationCollectionViewCell else {
                return STRegisterLocationCollectionViewCell()
            }
            
            let location = nearCities[indexPath.item].fullName
            cell.locationLabel.text = location
            
            if indexPath.row == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
            
            return cell
            
        }
        
        if collectionView == jobCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobCell", for: indexPath) as? STRegisterJobCollectionViewCell else {
                return STRegisterJobCollectionViewCell()
            }
            
            let job = industryList[indexPath.item]
            cell.jobLabel.text = job
            cell.layer.borderColor = UIColor.systemGray5.cgColor
            cell.layer.borderWidth = 0.5
            
            if industryList[indexPath.row] == self.selectedIndustry {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }
}

extension STJoinRegisterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == locationCollectionView {
            self.locationTextField.text = self.nearCities[indexPath.row].fullName
        } else if collectionView == jobCollectionView {
            self.selectedIndustry = self.industryList[indexPath.row]
        }
    }
}

extension STJoinRegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == locationCollectionView {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = collectionView.frame.height / 5
            return CGSize(width: width, height: height )
        }
        else if collectionView == jobCollectionView {
            let width = collectionView.frame.width / 3
            let height = collectionView.frame.height / 4
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 0.0, height: 0.0 )
    }
}

fileprivate extension String {
    func isValidChar() -> Bool {
        let nickRegEx = "[가-힣A-Za-z0-9]+"
        let pred = NSPredicate(format:"SELF MATCHES %@", nickRegEx)
        return pred.evaluate(with: self)
    }
    
    func isConformLengthLimit() -> Bool {
        return self.count >= 2 && self.count < 9
    }
}

extension STJoinRegisterViewController: CLLocationManagerDelegate {
    private func requestLocationAuth() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = Location(longitude: Double(location.coordinate.longitude), latitude: Double(location.coordinate.latitude))
        fetchProfile()
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
