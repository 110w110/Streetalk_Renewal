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
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.navigationBar.tintColor = .streetalkPink
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.streetalkPink]
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func presentHomeViewController() {
        DispatchQueue.main.async {
            // homeViewController
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! STHomeViewController
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

}
