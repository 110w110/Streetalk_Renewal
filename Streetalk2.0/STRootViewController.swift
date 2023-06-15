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
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! STHomeViewController
            
            let navigationController = UINavigationController(rootViewController: homeViewController)
            
            // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
            let tabBarController = STTabBarController()
            tabBarController.setViewControllers([navigationController], animated: false)
            tabBarController.modalPresentationStyle = .fullScreen
            tabBarController.tabBar.backgroundColor = .white
            
            guard let items = tabBarController.tabBar.items else { return }
//            items[0].image = UIImage(systemName: "square.and.arrow.up")
            // 중간 아이템 block
//            if  let arrayOfTabBarItems = tabBarController.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
//                tabBarItem.isEnabled = false
//            }
            
            tabBarController.modalPresentationStyle = .overFullScreen
            tabBarController.modalTransitionStyle = .crossDissolve
                self.present(tabBarController, animated: true, completion: nil)
            }
            return
        }
    

}
