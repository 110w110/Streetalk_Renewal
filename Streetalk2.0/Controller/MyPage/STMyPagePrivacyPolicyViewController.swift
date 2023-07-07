//
//  STMyPagePrivacyPolicyViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/23.
//

import UIKit

class STMyPagePrivacyPolicyViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getContents()
        // Do any additional setup after loading the view.
    }
    
    
    private func getContents() {
        let request = PolicyRequest()
        request.request(completion: { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.textView.text = data.privatePolicy?.replacingOccurrences(of: "\\n", with: "\n")
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.textView.text = "잠시 후 다시 시도해주세요."
                }
            }
        })
    }

}
