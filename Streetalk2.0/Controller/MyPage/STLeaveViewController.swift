//
//  STLeaveViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/08/02.
//

import UIKit

class STLeaveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func leaveButtonTapped(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "myPagePopUpViewController") as! STMyPagePopUpViewController
        viewController.popUpTitle = "회원 탈퇴"
        viewController.popUpContent = "확인을 누르시면 되돌릴 수 없습니다."
        viewController.popUpUsage = .leave
        viewController.targetViewController = self
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
}
