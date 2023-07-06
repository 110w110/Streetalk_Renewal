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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        replyTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUI()
        
        // get post 후 completion에서 post 내용 받아온 후 tableview reload data
        guard let id = postId else { return }
        let request = GetPostRequest(additionalInfo: "\(id)")
        request.request(completion: { result in
            switch result {
            case let .success(data):
                self.post = data
            case let .failure(error):
                print(error)
            }
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
}

extension STPostViewController {
    
    private func setUI() {
        bottomView.setRoundedBorder(shadow: true, bottomExtend: true)
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
//        return reply.count + 1
        return 3
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
            return cell
            
        }
    }
    
}

extension STPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
