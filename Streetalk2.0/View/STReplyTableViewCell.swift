//
//  STReplyTableViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/04.
//

import UIKit

class STReplyTableViewCell: UITableViewCell {

    @IBOutlet var cellBackground: UIView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var modifyButton: UIButton!
    
    var targetViewController: STPostViewController?
    var replyId: Int?
    var hasAuthority: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackground.setRoundedBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func modifyButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "replyModifyViewController") as! STReplyModifyViewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        viewController.content = contentLabel.text
        viewController.replyId = replyId
        viewController.handler = {
            self.targetViewController?.setUI()
        }
        guard let targetViewController = targetViewController else { return }
        targetViewController.present(viewController, animated: true)
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        guard let hasAuthority = hasAuthority else { return }
        switch hasAuthority {
        case true:
            let alert = UIAlertController(title: nil, message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                let request = URLSessionRequest<String>(uri: "/reply/", methods: .delete, additionalInfo: self.replyId?.toString())
                request.request(completion: { result in
                    var alert: UIAlertController
                    switch result {
                    case .success(_):
                        alert = UIAlertController(title: nil, message: "댓글 삭제에 성공하였습니다.", preferredStyle: .alert)
                    case .failure(_):
                        alert = UIAlertController(title: nil, message: "댓글 삭제에 실패하였습니다.", preferredStyle: .alert)
                    }
                    let okay = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(okay)
                    DispatchQueue.main.async {
                        self.targetViewController?.present(alert, animated: true)
                        self.targetViewController?.setUI()
                    }
                })
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancel)
            alert.addAction(confirm)
            DispatchQueue.main.async {
                self.targetViewController?.present(alert, animated: true)
            }
        case false:
            let storyboard = UIStoryboard(name: "Board", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "reportViewController") as! STReportViewController
            viewController.target = .reply
            viewController.replyId = replyId
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            guard let targetViewController = targetViewController else { return }
            targetViewController.present(viewController, animated: true)
        }
    }
    
}
