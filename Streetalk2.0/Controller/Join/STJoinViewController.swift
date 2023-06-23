//
//  STJoinViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/13.
//

import UIKit

class STJoinViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
//        self.dismiss(animated: true)
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "joinMobileAuthViewController") as! STJoinMobileAuthViewController
        nextViewController.title = "본인인증하기"
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
