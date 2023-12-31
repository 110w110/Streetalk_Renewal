//
//  STTabBarController.swift
//  Streetalk2.0
//
//  Created by 한태희 [hantae] on 2023/03/31.
//

import UIKit

class STTabBarController: UITabBarController, UITabBarControllerDelegate {

    private var addButton: UIButton = UIButton()
    private var isUploadTabBarEnabled = true
    var targetBoardID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        setupMiddleButton()
    }
    

    //코드로 탭바 가운데 버튼 넣기
    func setupMiddleButton(){
        addButton.backgroundColor = .clear
        addButton.setImage(UIImage(named: "Write"), for: UIControl.State.normal)
        
        addButton.backgroundColor = UIColor.clear
        addButton.layer.cornerRadius = 24
        
        addButton.contentMode = .scaleToFill
        addButton.addTarget(self, action: #selector(self.addButtonAction(sender:)), for: UIControl.Event.touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.tabBar.addSubview(addButton)
        
        NSLayoutConstraint(item: addButton, attribute: .centerX, relatedBy: .equal, toItem: self.tabBar, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addButton.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 36).isActive = true
        
        self.view.layoutIfNeeded()
    }

    // floating button 액션
    @objc func addButtonAction(sender: UIButton) {
        showWriteViewController()
    }
    
    // 글쓰기 탭 선택 시 탭이 넘어가지 않고 글쓰기 뷰컨만 올라오도록 유도
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "글쓰기" {
            let previousIndex = self.selectedIndex
            self.selectedIndex = previousIndex
            isUploadTabBarEnabled = false
            showWriteViewController()
        } else {
            isUploadTabBarEnabled = true
        }
    }
    
    // 실제로 글쓰기 뷰컨을 띄우는 메서드
    private func showWriteViewController() {
        // writeViewController
        let writeStoryboard = UIStoryboard(name: "Write", bundle: nil)
        let writeViewController = writeStoryboard.instantiateViewController(withIdentifier: "writeViewController") as! STWriteViewController
        writeViewController.title = "글쓰기"
        if let id = targetBoardID {
            writeViewController.targetBoardId = id
        }
        let navigationController = UINavigationController(rootViewController: writeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return isUploadTabBarEnabled
    }
    
}

extension UITabBar {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false

    }
}
