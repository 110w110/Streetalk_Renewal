//
//  STWriteViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STWriteViewController: UIViewController {

    @IBOutlet weak var writeContentTextView: STTextView!
    @IBOutlet weak var writtingBackgroundImageView: UIImageView!
    @IBOutlet var keyboardArea: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        writeContentTextView.delegate = self
        writeContentTextView.setPlaceholder(placeholder: "게시글 내용을 작성해주세요.")
        
//        .keyboardDismissMode = .onDrag
        lazy var rightButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(writeButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func writeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension STWriteViewController: UITextViewDelegate {
    
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        self.keyboardArea.isHidden = false
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        self.keyboardArea.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
