//
//  STWriteViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STWriteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var writeContentTextView: STTextView!
    @IBOutlet weak var writtingBackgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        writeContentTextView.delegate = self
        writeContentTextView.setPlaceholder(placeholder: "게시글 내용을 작성해주세요.")
        
        lazy var rightButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(writeButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let contentTextView = textView as! STTextView
        if contentTextView.text == "" {
            contentTextView.text = contentTextView.placeholder
            contentTextView.textColor = .placeholderText
            self.writtingBackgroundImageView.isHidden = false
        } else {
            self.writtingBackgroundImageView.isHidden = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.writtingBackgroundImageView.isHidden = true
        let contentTextView = textView as! STTextView
        if contentTextView.text == contentTextView.placeholder {
            contentTextView.text = ""
            contentTextView.textColor = .label
        }
    }
    
    @objc func writeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
