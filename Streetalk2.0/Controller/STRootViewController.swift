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
        checkUserToken()
    }
    
    private func checkUserToken() {
        if UserDefaults.standard.string(forKey: "userToken") == nil {
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
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.navigationBar.tintColor = .streetalkPink
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.streetalkPink]
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func presentHomeViewController() {
        DispatchQueue.main.async {
            let mainViewController = STMainViewController()
            mainViewController.modalPresentationStyle = .overFullScreen
            mainViewController.modalTransitionStyle = .crossDissolve
            self.present(mainViewController, animated: true, completion: nil)
        }
    }

}
