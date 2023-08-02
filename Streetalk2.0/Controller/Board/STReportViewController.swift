//
//  STReportViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/06.
//

import UIKit

class STReportViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var reasonTextField: UITextField!
    
    var target: reportTarget = .post
    
    private let reasons: [String] = ["불건전한 내용","스팸 및 광고성","개인정보 노출","선정적/폭력적 내용","도배","기타"]
    
    var postId: Int?
    var replyId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.backgroundColor = .label.withAlphaComponent(0.2)
        backgroundView.setRoundedBorder()
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        switch target {
        case .post:
            reportPost()
        case .reply:
            reportReply()
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func reportPost() {
        guard let postId = postId, let reason = reasonTextField.text else { return }
        let request = URLSessionRequest<Bool>(uri: "/lockPost", methods: .post, param: ["postId" : postId, "lockInfo" : reason])
        request.request(completion: { result in
            switch result {
            case let .success(data):
                var alert: UIAlertController
                if data {
                    alert = UIAlertController(title: "신고", message: "정상적으로 신고되었습니다.", preferredStyle: .alert)
                } else {
                    alert = UIAlertController(title: "신고", message: "이미 신고된 게시글입니다.", preferredStyle: .alert)
                }
                DispatchQueue.main.async {
                    let okay = UIAlertAction(title: "확인", style: .default) { action in
                        self.dismiss(animated: true)
                    }
                    alert.addAction(okay)
                    self.present(alert, animated: true)
                }
            case let .failure(error):
                print(error)
                self.errorMessage(error: error, message: #function)
            }
        })
    }
    
    private func reportReply() {
        guard let replyId = replyId, let reason = reasonTextField.text else { return }
        let request = URLSessionRequest<Bool>(uri: "/lockReply", methods: .post, param: ["replyId" : replyId, "lockInfo" : reason])
        request.request(completion: { result in
            switch result {
            case let .success(data):
                var alert: UIAlertController
                if data {
                    alert = UIAlertController(title: "신고", message: "정상적으로 신고되었습니다.", preferredStyle: .alert)
                } else {
                    alert = UIAlertController(title: "신고", message: "이미 신고된 댓글입니다.", preferredStyle: .alert)
                }
                DispatchQueue.main.async {
                    let okay = UIAlertAction(title: "확인", style: .default) { action in
                        self.dismiss(animated: true)
                    }
                    alert.addAction(okay)
                    self.present(alert, animated: true)
                }
            case let .failure(error):
                print(error)
                self.errorMessage(error: error, message: #function)
            }
        })
    }
}

extension STReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let label = {
            let label = UILabel()
            label.text = self.reasons[indexPath.row]
            label.font = UIFont.systemFont(ofSize: 14.0)
            return label
        }()
        cell.selectionStyle = .none
        cell.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        return cell
    }
    
}

extension STReportViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reasonTextField.text = reasons[indexPath.row]
    }
    
}

enum reportTarget {
    case post
    case reply
}
