//
//  STRootViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkPassword()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkUserToken()
    }
    
    private func checkPassword() {
        if let password = UserDefaults.standard.string(forKey: "localPassword"), password != "" {
            let handler = {
                self.dismiss(animated: true) {
                    self.checkUserToken()
                }
            }
            let storyboard = UIStoryboard(name: "Password", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "passwordViewController") as? STPasswordViewController else { return }
            viewController.mode = .check
            viewController.passHandler = handler
            let navigation = UINavigationController(rootViewController: viewController)
            navigation.modalPresentationStyle = .fullScreen
            navigation.hidesBottomBarWhenPushed = true
            DispatchQueue.main.async {
                self.present(navigation, animated: true)
            }
        } else {
            checkUserToken()
        }
    }
    
    private func checkUserToken() {
        if UserDefaults.standard.string(forKey: "userToken") != nil {
            let request = URLSessionRequest<Token>(uri: "/user/refreshToken", methods: .put)
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    UserDefaults.standard.set(data.token, forKey: "userToken")
                    self.presentHomeViewController()
                case let .failure(error):
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: error.failureReason, message: "이용이 제한된 사용자입니다.\ndev.hantae@gmail.com으로 문의 바랍니다.", preferredStyle: .alert)
                        let okay = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        } else {
            presentJoinViewController()
        }
    }
    
    private func presentJoinViewController() {
        DispatchQueue.main.async {
            let joinStoryboard = UIStoryboard(name: "Join", bundle: nil)
            let joinViewController = joinStoryboard.instantiateViewController(withIdentifier: "joinViewController")
            let navigationController = UINavigationController(rootViewController: joinViewController)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.navigationBar.tintColor = .streetalkPink
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.streetalkPink]
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func presentHomeViewController() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        
        guard let appVersion = appVersion, let appBuildNumber = appBuildNumber else { return }
        let currentFullVersion = appVersion + appBuildNumber
        
        let request = URLSessionRequest<Version>(uri: "/version", methods: .get)
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                let minimumFullVersion = "1.0.10"
                let latestFullVerseion = "1.0.10"
                switch self.versionCheck(current: currentFullVersion, minimum: minimumFullVersion, latest: latestFullVerseion) {
                case .need:
                    let alert = UIAlertController(title: nil, message: "필수 업데이트가 있습니다", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "업데이트", style: .default) { _ in
                        guard let url = URL(string: "itms-apps://itunes.apple.com/app/6451136628") else { return }
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    alert.addAction(okay)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)

                        let mainViewController = STMainViewController()
                        mainViewController.modalPresentationStyle = .fullScreen
                        mainViewController.modalTransitionStyle = .crossDissolve
                        self.present(mainViewController, animated: true, completion: nil)
                    }
                case .outOfDate:
                    let alert = UIAlertController(title: nil, message: "최신 버전이 업데이트 되었습니다", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "업데이트", style: .default) { _ in
                        guard let url = URL(string: "itms-apps://itunes.apple.com/app/6451136628") else { return }
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    let later = UIAlertAction(title: "나중에", style: .cancel) { _ in
                        let mainViewController = STMainViewController()
                        mainViewController.modalPresentationStyle = .fullScreen
                        mainViewController.modalTransitionStyle = .crossDissolve
                        self.present(mainViewController, animated: true, completion: nil)
                    }
                    alert.addAction(later)
                    alert.addAction(okay)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                case .upToDate:
                    DispatchQueue.main.async {
                        let mainViewController = STMainViewController()
                        mainViewController.modalPresentationStyle = .fullScreen
                        mainViewController.modalTransitionStyle = .crossDissolve
                        self.present(mainViewController, animated: true, completion: nil)
                    }
                }
            case let .failure(error):
                print(error)
            }
        })
        
//        DispatchQueue.main.async {
//            let mainViewController = STMainViewController()
//            mainViewController.modalPresentationStyle = .fullScreen
//            mainViewController.modalTransitionStyle = .crossDissolve
//            self.present(mainViewController, animated: true, completion: nil)
//        }
        
    }
    
    private func versionCheck(current: String, minimum: String, latest: String) -> Update {
        let currentVersionNumber = current.components(separatedBy: ".").map { Int($0) ?? 0 }
        let minimumVersionNumber = minimum.components(separatedBy: ".").map { Int($0) ?? 0 }
        let latestVersionNumber = latest.components(separatedBy: ".").map { Int($0) ?? 0 }
        
        for i in 0 ..< currentVersionNumber.count {
            if currentVersionNumber[i] < minimumVersionNumber[i] {
                return .need
            } else if currentVersionNumber[i] < latestVersionNumber[i] {
                return .outOfDate
            }
        }
        
        return .upToDate
    }
}

fileprivate enum Update {
    case need
    case outOfDate
    case upToDate
}
