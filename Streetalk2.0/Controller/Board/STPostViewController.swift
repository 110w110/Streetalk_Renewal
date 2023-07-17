//
//  STPostViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/26.
//

import UIKit
import Kingfisher

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
    private var hasAuthority: Bool = false
    
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
        let request = PostReplyRequest(param: ["postId" : postId, "content" : text, "checkName" : anonymous, "isPrivate" : anonymous])
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
    
    func setUI() {
        bottomView.setRoundedBorder(shadow: true, bottomExtend: true)

        guard let id = postId else { return }
        let request = GetPostRequest(additionalInfo: "\(id)")
        request.request(completion: { result in
            switch result {
            case let .success(data):
                self.post = data
                self.replies = data.replyList ?? []
                self.hasAuthority = data.hasAuthority ?? false
            case let .failure(error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.hasAuthority ? "삭제" : "신고", style: .plain, target: self, action: #selector(self.optionButtonTapped))
            }
        })
    }
    
    @objc private func optionButtonTapped() {
        switch hasAuthority {
        case true:
            deletePost()
        case false:
            showReportViewController()
        }
    }
    
    private func deletePost() {
        let alert = UIAlertController(title: "삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            let request = PostDeleteRequest(additionalInfo: self.postId?.toString())
            request.request(completion: { result in
                var alert: UIAlertController
                switch result {
                case .success(_):
                    alert = UIAlertController(title: "게시글 삭제", message: "게시글 삭제에 성공하였습니다.", preferredStyle: .alert)
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(_):
                    alert = UIAlertController(title: "게시글 삭제", message: "게시글 삭제에 실패하였습니다.", preferredStyle: .alert)
                }
                let okay = UIAlertAction(title: "확인", style: .default)
                alert.addAction(okay)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            })
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(confirm)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        
    }
    
    private func showReportViewController() {
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
            cell.secondaryNickNameStackView.isHidden = false
            if let post = post {
                cell.titleLabel.text = post.title
                cell.contentLabel.text = post.content
                cell.nickNameLabel.text = post.postWriterName?.toNameWithIndustry(industry: post.industry)
                cell.postTimeLabel.text = post.lastTime?.toLastTimeString()
                cell.commentCount.text = post.replyCount?.toString()
                cell.likeCount.text = post.likeCount?.toString()
                cell.scrapCount.text = post.scrapCount?.toString()
                cell.like = post.likeCount
                cell.scrap = post.scrapCount
                cell.postId = self.postId
                cell.likeImage.isHighlighted = post.postLike ?? false
                cell.scrapImage.isHighlighted = post.postScrap ?? false
                cell.imageUrls = post.images
                cell.imageCollectionView.isHidden = post.images?.count == 0
                DispatchQueue.main.async {
                    cell.imageCollectionView.reloadData()
                }
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
                cell.hasAuthority = hasAuthority
                cell.replyButton.setTitle(hasAuthority ? "삭제" : "신고", for: .normal)
                if post?.postWriterId == replies[indexPath.row - 1].replyWriterId {
                    cell.cellBackground.layer.borderColor = UIColor.streetalkPink.cgColor
                    cell.nickNameLabel.text = "작성자"
                }
            }
            return cell
            
        }
    }
    
}

extension STPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
