//
//  STReplyModifyViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/20.
//

import UIKit

class STReplyModifyViewController: UIViewController {

    @IBOutlet var popUpView: UIView!
    @IBOutlet var topMargin: UIView!
    @IBOutlet var bottomMargin: UIView!
    
    @IBOutlet var textView: UITextView!
    
    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        self.view.backgroundColor = .label.withAlphaComponent(0.2)
        popUpView.setRoundedBorder()
        
        textView.becomeFirstResponder()
        textView.text = content
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}

extension STReplyModifyViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2, animations: {
            self.topMargin.isHidden = false
            self.bottomMargin.isHidden = true
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.2, animations: {
            self.topMargin.isHidden = true
            self.bottomMargin.isHidden = false
        })
        
    }
}
