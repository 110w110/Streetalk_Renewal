//
//  STJoinRegisterViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import UIKit

class STJoinRegisterViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate {
    
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
    
    // 서버에서 동네 정보 가져와야 함
    private let debugingLocationList: [String] = ["서울 마포구 대흥동", "서울 마포구 서교동", "서울 마포구 신수동", "서울 마포구 연남동", "서울 마포구 합정동"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        nickNameTextField.becomeFirstResponder()
        
        nicknameSectionView.setRoundedBorder()
        locationSectionView.setRoundedBorder()
        jobSectionView.setRoundedBorder()
        jobCollectionView.setRoundedBorder()
        
        nickNameTextField.delegate = self
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        
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
            // homeViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! STHomeViewController
            homeViewController.title = "Streetalk"
            
            // boardListViewController
            let boardStoryboard = UIStoryboard(name: "Board", bundle: nil)
            let boarListViewController = boardStoryboard.instantiateViewController(withIdentifier: "boardListViewController")
            boarListViewController.title = "게시판"
            
            // writeViewController
            let writeStoryboard = UIStoryboard(name: "Write", bundle: nil)
            let writeViewController = writeStoryboard.instantiateViewController(withIdentifier: "writeViewController")
            writeViewController.title = "글쓰기"
            
            // alertListViewController
            let alertStoryboard = UIStoryboard(name: "Alert", bundle: nil)
            let alertListViewController = alertStoryboard.instantiateViewController(withIdentifier: "alertListViewController")
            alertListViewController.title = "알림"
            
            // myPageListViewController
            let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
            let myPageListViewController = myPageStoryboard.instantiateViewController(withIdentifier: "myPageListViewController")
            myPageListViewController.title = "마이페이지"
            
            let navigationController = UINavigationController(rootViewController: homeViewController)
            navigationController.navigationBar.tintColor = .streetalkPink
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.streetalkPink]
            
            // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
            let tabBarController = STTabBarController()
            tabBarController.setViewControllers([navigationController, boarListViewController,writeViewController,alertListViewController,myPageListViewController], animated: false)
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.tabBar.backgroundColor = .white
            tabBarController.tabBar.tintColor = .streetalkPink
            
            guard let items = tabBarController.tabBar.items else { return }
            items[0].title = "Home"
            items[0].image = UIImage(named: "Home_Normal")
            items[0].selectedImage = UIImage(named: "Home_Highlight")
            items[1].image = UIImage(named: "Board_Normal")
            items[1].selectedImage = UIImage(named: "Board_Highlight")
            
            items[3].image = UIImage(named: "Alert_Normal")
            items[3].selectedImage = UIImage(named: "Alert_Highlight")
            items[4].image = UIImage(named: "MyPage_Normal")
            items[4].selectedImage = UIImage(named: "MyPage_Highlight")
            
            tabBarController.modalPresentationStyle = .overFullScreen
            tabBarController.modalTransitionStyle = .crossDissolve
            self.present(tabBarController, animated: true, completion: nil)
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

extension STJoinRegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return debugingLocationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as? STRegisterLocationCollectionViewCell else {
            return STRegisterLocationCollectionViewCell()
        }
        
        let location = debugingLocationList[indexPath.item]
        cell.locationLabel.text = location
        
        return cell
    }
}

extension STJoinRegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 20.0
        return CGSize(width: width, height: height )
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
