//
//  STMainViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 [hantae] on 2023/03/31.
//

import UIKit

class STMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentHomeViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("A")
        self.dismiss(animated: true)
    }

    private func presentHomeViewController() {
        DispatchQueue.main.async {
            // homeViewController
            let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = MainStoryboard.instantiateViewController(withIdentifier: "homeViewController") as! STHomeViewController
            homeViewController.title = "Streetalk"
            let homeNavigationController = UINavigationController(rootViewController: homeViewController)
            homeNavigationController.navigationBar.tintColor = .streetalkPink
            homeNavigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.streetalkPink]
            
            // boardListViewController
            let boardStoryboard = UIStoryboard(name: "Board", bundle: nil)
            let boardListViewController = boardStoryboard.instantiateViewController(withIdentifier: "boardListViewController")
            boardListViewController.title = "게시판"
            let boardListNavigationController = UINavigationController(rootViewController: boardListViewController)
            boardListNavigationController.navigationBar.tintColor = .streetalkPink
            
            // writeViewController
            let writeStoryboard = UIStoryboard(name: "Write", bundle: nil)
            let writeViewController = writeStoryboard.instantiateViewController(withIdentifier: "writeViewController")
            writeViewController.title = "글쓰기"
            
            // searchListViewController
            let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
            let searchListViewController = searchStoryboard.instantiateViewController(withIdentifier: "searchListViewController")
            searchListViewController.title = "검색"
            let searchListNavigationController = UINavigationController(rootViewController: searchListViewController)
            searchListNavigationController.navigationBar.tintColor = .streetalkPink
            
            // myPageListViewController
            let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
            let myPageListViewController = myPageStoryboard.instantiateViewController(withIdentifier: "myPageListViewController")
            myPageListViewController.title = "마이페이지"
            let myPageListNavigationController = UINavigationController(rootViewController: myPageListViewController)
            myPageListNavigationController.navigationBar.tintColor = .streetalkPink
            
            
            // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
            let tabBarController = STTabBarController()
            tabBarController.setViewControllers([homeNavigationController, boardListNavigationController,writeViewController,searchListNavigationController,myPageListNavigationController], animated: false)
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.tabBar.backgroundColor = .systemBackground
            tabBarController.tabBar.clipsToBounds = false
            
            tabBarController.tabBar.tintColor = .streetalkPink
            
            guard let items = tabBarController.tabBar.items else { return }
            items[0].title = "Home"
            items[0].image = UIImage(named: "Home_Normal")
            items[0].selectedImage = UIImage(named: "Home_Highlight")
            items[1].image = UIImage(named: "Board_Normal")
            items[1].selectedImage = UIImage(named: "Board_Highlight")
            
            items[3].image = UIImage(named: "Search_Normal")
            items[3].selectedImage = UIImage(named: "Search_Highlight")
            items[4].image = UIImage(named: "MyPage_Normal")
            items[4].selectedImage = UIImage(named: "MyPage_Highlight")
            
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.modalTransitionStyle = .crossDissolve
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
    
}
