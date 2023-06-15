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
            
            // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
            let tabBarController = STTabBarController()
            tabBarController.setViewControllers([navigationController, boarListViewController,writeViewController,alertListViewController,myPageListViewController], animated: false)
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.tabBar.backgroundColor = .white
            
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
            
            // 중간 아이템 block
//            if  let arrayOfTabBarItems = tabBarController.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
//                tabBarItem.isEnabled = false
//            }
            // block 하지말고 탭바 아이템 2번 선택 시 글쓰기 버튼과 동일하게 뷰컨을 팝업으로 띄우도록 하는게 좋을듯
            
            tabBarController.modalPresentationStyle = .overFullScreen
            tabBarController.modalTransitionStyle = .crossDissolve
                self.present(tabBarController, animated: true, completion: nil)
            }
            return
        }
    

}
