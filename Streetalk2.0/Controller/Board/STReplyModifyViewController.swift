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
    var replyId: Int?
    var handler: (() -> ())?
    
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
    
    @IBAction func modifyButtonTapped(_ sender: Any) {
        guard let text = textView.text, let id = replyId else { return }
        let request = URLSessionRequest<String>(uri: "/reply", methods: .put, param: ["replyId" : id, "content" : text])
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        if let handler = self.handler {
                            handler()
                        }
                    }
                }
            case let .failure(error):
                print(error)
            }
        })
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
