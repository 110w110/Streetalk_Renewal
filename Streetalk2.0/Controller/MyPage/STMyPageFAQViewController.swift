//
//  STMyPageFAQViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/23.
//

import UIKit
import MessageUI

class STMyPageFAQViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = "\n문의 사항은 아래의 메일로 주시면 검토 후 연락 드리겠습니다.\n(dev.hantae@gmail.com)"
        textView.delegate = self
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
    }
    
}

extension STMyPageFAQViewController: UITextViewDelegate, MFMailComposeViewControllerDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            compseVC.setToRecipients(["dev.hantae@gmail.com"])
            compseVC.setSubject("Streetalk Asking Mail")
            let body = """
                         -------------------
                         
                         Device Model : \(self.getDeviceIdentifier())
                         Device OS : \(UIDevice.current.systemVersion)
                         App Version : \(self.getCurrentVersion())
                         
                         -------------------
                         
                         아래에 문의하실 내용에 대해 작성해주세요.
                         
                         
                         """
            compseVC.setMessageBody(body, isHTML: false)
            self.present(compseVC, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
        return false
    }
}
