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
    @IBOutlet var anonymousButton: UIButton!
    
    var postId: Int?
    private var post: Post?
    private var replies: [Reply] = []
    private var anonymous: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        replyTextField.delegate = self
        
        tableView.keyboardDismissMode = .onDrag
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setUI()
        setAnonymousButton()
        
    }
    
    @IBAction func replySubmitButtonTapped(_ sender: Any) {
        if self.replyTextField.text == "" { return }
        replyTextField.endEditing(false)
        
        guard let postId = postId, let text = self.replyTextField.text else { return }
        let request = PostReplyRequest(param: ["postId" : postId, "content" : text, "checkName" : anonymous])
        request.request(completion: {result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.setUI()
                    self.replyTextField.text = ""
                    self.tableView.reloadData()
                    
                    let lastIndex = IndexPath(row: self.post?.replyList?.count ?? 0, section: 0)
                    self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
                }
            case let .failure(error):
                print(error)
                DispatchQueue.main.async {
                    self.replyTextField.text = ""
                    let alert = UIAlertController(title: "댓글 작성 실패", message: "댓글 작성에 실패했습니다.\n\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
        })
    }
    
    @IBAction func anonymousButtonTapped(_ sender: Any) {
        self.anonymous = !self.anonymous
        print(anonymous)
        setAnonymousButton()
    }
}

extension STPostViewController {
    
    private func setAnonymousButton() {
        DispatchQueue.main.async {
            if self.anonymous {
                self.anonymousButton.setTitle("익명", for: .selected)
                self.anonymousButton.tintColor = .streetalkPink
            } else {
                self.anonymousButton.setTitle("실명", for: .selected)
                self.anonymousButton.tintColor = .streetalkOrange
            }
        }
    }
    private func setUI() {
        bottomView.setRoundedBorder(shadow: true, bottomExtend: true)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "신고", style: .plain, target: self, action: #selector(showReportViewController))

        guard let id = postId else { return }
        let request = GetPostRequest(additionalInfo: "\(id)")
        request.request(completion: { result in
            switch result {
            case let .success(data):
                self.post = data
                self.replies = data.replyList ?? []
                print(data.hasAuthority)
//                print(data.replyList)
            case let .failure(error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    @objc private func showReportViewController() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "reportViewController") as! STReportViewController
        viewController.postId = self.postId
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true)
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
                cell.postTimeLabel.text = post.lastTime?.toLastTimeString()
                cell.commentCount.text = post.replyCount?.toString()
                cell.likeCount.text = post.likeCount?.toString()
                cell.scrapCount.text = post.scrapCount?.toString()
                cell.like = post.likeCount
                cell.scrap = post.scrapCount
                cell.postId = self.postId
                cell.likeImage.isHighlighted = post.postLike ?? false
                cell.scrapImage.isHighlighted = post.postScrap ?? false
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "replyTableViewCell", for: indexPath) as! STReplyTableViewCell
            cell.selectionStyle = .none
            cell.targetViewController = self
            cell.replyId = replies[indexPath.row - 1].replyId
            cell.nickNameLabel.text = replies[indexPath.row - 1].replyWriterName
            cell.contentLabel.text = replies[indexPath.row - 1].content
            cell.timeLabel.text = replies[indexPath.row - 1].lastTime?.toLastTimeString()
            if let hasAuthority = replies[indexPath.row - 1].hasAuthority {
                cell.replyButton.setTitle(hasAuthority ? "삭제" : "신고", for: .normal)
            }
            return cell
            
        }
    }
    
}

extension STPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
