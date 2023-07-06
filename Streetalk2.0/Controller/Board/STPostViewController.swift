//
//  STPostViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/26.
//

import UIKit

class STPostViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var keyboardArea: UIView!
    @IBOutlet var replyTextField: UITextField!
    
    var postId: Int?
    private var post: Post?
    private var replies: [Reply] = []
    private var anonymous: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        replyTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUI()
        
    }
    
    @IBAction func replySubmitButtonTapped(_ sender: Any) {
        if self.replyTextField.text == "" { return }
        
        guard let postId = postId, let text = self.replyTextField.text else { return }
        let request = PostReplyRequest(param: ["postId" : postId, "content" : text, "checkName" : anonymous])
        request.request(completion: {result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.setUI()
                    self.replyTextField.text = ""
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
                DispatchQueue.main.async {
                    self.replyTextField.text = ""
                }
            }
        })
    }
    
}

extension STPostViewController {
    
    private func setUI() {
        bottomView.setRoundedBorder(shadow: true, bottomExtend: true)
        
        guard let id = postId else { return }
        let request = GetPostRequest(additionalInfo: "\(id)")
        request.request(completion: { result in
            switch result {
            case let .success(data):
                self.post = data
                self.replies = data.replyList ?? []
            case let .failure(error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
}

extension STPostViewController: UITextFieldDelegate {
    
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

extension STPostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postContentTableViewCell", for: indexPath) as! STPostTableViewCell
            cell.selectionStyle = .none
            cell.primaryNickNameStackView.isHidden = true
            cell.secondaryNickNameStackView.isHidden = false
            if let post = post {
                cell.titleLabel.text = post.title
                cell.contentLabel.text = post.content
                cell.nickNameLabel.text = post.postWriterName
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "replyTableViewCell", for: indexPath) as! STReplyTableViewCell
            cell.selectionStyle = .none
            cell.nickNameLabel.text = replies[indexPath.row - 1].replyWriterName
            cell.contentLabel.text = replies[indexPath.row - 1].content
            cell.timeLabel.text = String(replies[indexPath.row - 1].lastTime ?? 0)
            return cell
            
        }
    }
    
}

extension STPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
