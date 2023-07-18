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
            viewController.title = title
            viewController.mode = .check
            viewController.passHandler = handler
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            DispatchQueue.main.async {
                self.present(viewController, animated: true)
            }
        } else {
            checkUserToken()
        }
    }
    
    private func checkUserToken() {
        if UserDefaults.standard.string(forKey: "userToken") != nil {
            presentHomeViewController()
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
        DispatchQueue.main.async {
            let mainViewController = STMainViewController()
            mainViewController.modalPresentationStyle = .fullScreen
            mainViewController.modalTransitionStyle = .crossDissolve
            self.present(mainViewController, animated: true, completion: nil)
        }
    }

}
