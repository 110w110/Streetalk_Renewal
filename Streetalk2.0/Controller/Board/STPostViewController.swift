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
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        replyTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        setUI()
        setAnonymousButton()
        
    }
    
    @IBAction func replySubmitButtonTapped(_ sender: Any) {
        guard let text = self.replyTextField.text, !text.isRealEmptyText() else { return }
//        if self.replyTextField.text == ""
        replyTextField.endEditing(false)
        
        guard let postId = postId, let text = self.replyTextField.text else { return }
        let request = PostReplyRequest(param: ["postId" : postId, "content" : text, "checkName" : anonymous, "isPrivate" : anonymous])
        request.request(completion: {result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.replyTextField.text = ""
                    self.tableView.reloadData()
                    self.setUI()
                    
                    let lastIndex = IndexPath(row: self.post?.replyList?.count ?? 0, section: 0)
                    self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
                }
            case let .failure(error):
                print(error)
                self.errorMessage(error: error, message: #function)
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
    
    @objc private func refreshUI() {
        print("refresh")
        setUI()
    }
    
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
                if error == .httpClient4xxError {
                    self.errorMessage(error: error, message: "삭제되었거나 존재하지 않는 게시글입니다.")
                } else {
                    self.errorMessage(error: error, message: #function)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.hasAuthority {
                    let modify = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(self.modifyButtonTapped))
                    let delete = UIBarButtonItem(title: "삭제", style: .done, target: self, action: #selector(self.deleteButtonTapped))
                    self.navigationItem.rightBarButtonItems = [delete]
                } else {
                    let report = UIBarButtonItem(title: "신고", style: .done, target: self, action: #selector(self.reportButtonTapped))
                    self.navigationItem.rightBarButtonItem = report
                }
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    @objc private func modifyButtonTapped() {
        let alert = UIAlertController(title: nil, message: "게시글을 수정하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "수정", style: .default) { _ in
            self.modifyPost()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(confirm)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(title: nil, message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.deletePost()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(confirm)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @objc private func reportButtonTapped() {
        showReportViewController()
    }
    
    private func modifyPost() {
        let storyboard = UIStoryboard(name: "Write", bundle: nil)
        let writeViewController = storyboard.instantiateViewController(identifier: "writeViewController") as! STWriteViewController
        writeViewController.mode = .put
        writeViewController.targetModifyPostId = self.postId
        writeViewController.title = "글쓰기"
        writeViewController.currentPostId = postId
        writeViewController.currentPost = post
        let navigationController = UINavigationController(rootViewController: writeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    private func deletePost() {
        let request = PostDeleteRequest(additionalInfo: self.postId?.toString())
        request.request(completion: { result in
            var alert: UIAlertController
            switch result {
            case .success(_):
                alert = UIAlertController(title: nil, message: "게시글 삭제에 성공하였습니다.", preferredStyle: .alert)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(_):
                alert = UIAlertController(title: nil, message: "게시글 삭제에 실패하였습니다.", preferredStyle: .alert)
            }
            let okay = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okay)
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        })
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
                let writerName = post.isPrivate ?? false ? "익명" : post.postWriterName
                cell.titleLabel.text = post.title
                cell.contentLabel.text = post.content
                cell.nickNameLabel.text = writerName?.toNameWithIndustry(industry: post.industry)
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
                cell.targetViewController = self
                cell.imageCollectionView.isHidden = post.images?.count == 0
                cell.cellBackground.layer.borderColor = UIColor.systemGray5.cgColor
                cell.setUI()
                DispatchQueue.main.async {
                    cell.imageCollectionView.reloadData()
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "replyTableViewCell", for: indexPath) as! STReplyTableViewCell
            let writerName = replies[indexPath.row - 1].isPrivate ?? false ? "익명" : replies[indexPath.row - 1].replyWriterName
            cell.selectionStyle = .none
            cell.targetViewController = self
            cell.replyId = replies[indexPath.row - 1].replyId
            cell.nickNameLabel.text = writerName
            cell.contentLabel.text = replies[indexPath.row - 1].content
            cell.timeLabel.text = replies[indexPath.row - 1].lastTime?.toLastTimeString()
            if let hasAuthority = replies[indexPath.row - 1].hasAuthority {
                cell.hasAuthority = hasAuthority
                cell.replyButton.setTitle(hasAuthority ? "삭제" : "신고", for: .normal)
                cell.modifyButton.isHidden = !hasAuthority
                if post?.postWriterId == replies[indexPath.row - 1].replyWriterId {
                    cell.cellBackground.layer.borderColor = UIColor.streetalkPink.cgColor
                    cell.nickNameLabel.text = "작성자"
                } else {
                    cell.cellBackground.layer.borderColor = UIColor.systemGray5.cgColor
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
