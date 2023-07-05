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
    @IBOutlet var nicknameSectionView: UIView!
    @IBOutlet var locationSectionView: UIView!
    @IBOutlet var jobSectionView: UIView!
    @IBOutlet var locationCollectionView: UICollectionView!
    @IBOutlet var jobCollectionView: UICollectionView!
    @IBOutlet var isValidNickNameLabel: UILabel!
    @IBOutlet var isValidCharLabel: UILabel!
    @IBOutlet var lengthLimitLabel: UILabel!
    @IBOutlet var confirmButton: STButton!
    
    private let locationManager = CLLocationManager()
    private var location: Location?
    private var token: String?
    
    private var nearCities: [Cities] = []
    private var industries: [String] = []
    
    var auth: [String : String]?
    
    // 서버에서 동네 정보 가져와야 함
//    private let debugingLocationList: [String] = ["서울 마포구 대흥동", "서울 마포구 서교동", "서울 마포구 신수동", "서울 마포구 연남동", "서울 마포구 합정동"]
    private let debugingJobList: [String] = ["식당", "카페", "주점", "오락", "미용", "숙박", "교육", "스포츠", "반려동물", "유통 및 제조", "의료", "패션"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        nickNameTextField.becomeFirstResponder()
        
        nicknameSectionView.setRoundedBorder()
        locationSectionView.setRoundedBorder()
        jobSectionView.setRoundedBorder()
        jobCollectionView.setRoundedBorder()
        
        locationManager.delegate = self
        requestLocationAuth()
        
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
    }
    
    @IBAction func nickNameTextFieldEditing(_ sender: Any) {
        guard let text = nickNameTextField.text else { return  }
        setNickNameCheckUI(nickname: text)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        // TODO: 가입 요청 보내보고 결과에 따라 분기 시켜야함
        showHomeViewController()
    }
    
    private func showHomeViewController() {
        DispatchQueue.main.async {
            let mainViewController = STMainViewController()
            mainViewController.modalPresentationStyle = .overFullScreen
            mainViewController.modalTransitionStyle = .crossDissolve
            self.present(mainViewController, animated: true, completion: nil)
        }
    }
    
    private func setNickNameCheckUI(nickname: String) {
        print(nickname)
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

extension STJoinRegisterViewController {
    
    private func requestLocationAuth() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    private func setLocation() {
        guard let phoneNum = auth?["phoneNum"], let authNum = auth?["authNum"], let longitude = self.location?.longitude, let latitude = self.location?.latitude else {
            print("Error: cannot request Login")
            print("Check phone number or auth number")
            return
        }
        let request = LoginRequest(param: ["phoneNum" : phoneNum, "longitude" : longitude, "latitude" : latitude, "randomNum" : authNum])
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                self.token = data.token
                self.nearCities = data.nearCities ?? []
                self.nearCities.insert(Cities(fullName: data.currentCity, id: nil), at: 0)
                DispatchQueue.main.async {
                    self.locationCollectionView.reloadData()
                }
                
            case let .failure(error):
                print(error)
            }
        })
    }
    
}

extension STJoinRegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == locationCollectionView {
            return nearCities.count
        }
        else if collectionView == jobCollectionView {
            return debugingJobList.count
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
            
            return cell
            
        }
        
        if collectionView == jobCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobCell", for: indexPath) as? STRegisterJobCollectionViewCell else {
                return STRegisterJobCollectionViewCell()
            }
            
            let job = debugingJobList[indexPath.item]
            print(job)
            dump(cell)
            cell.jobLabel.text = job
            cell.layer.borderColor = UIColor.systemGray5.cgColor
            cell.layer.borderWidth = 0.5
            
            return cell
            
        }
        
        return UICollectionViewCell()
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

extension STJoinRegisterViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = Location(longitude: Double(location.coordinate.longitude), latitude: Double(location.coordinate.latitude))
        setLocation()
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
