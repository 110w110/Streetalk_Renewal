//
//  STMyPageHelpViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/23.
//

import UIKit

class STMyPageNoticeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var noticeList: [Notice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        fetchNotice()
    }
    
}

extension STMyPageNoticeViewController {
    private func fetchNotice() {
        let request = URLSessionRequest<[Notice]>(uri: "/user/notice", methods: .get)
        request.request(completion: { result in
            switch result {
            case let .success(data):
                self.noticeList = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
                self.errorMessage(error: error, message: #function)
            }
        })
    }
}

extension STMyPageNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noticeViewController = self.storyboard?.instantiateViewController(withIdentifier: "noticeDetailViewController") as! STNoticeDetailViewController
        noticeViewController.title = "공지사항"
        noticeViewController.notice = noticeList?[indexPath.row]
        self.navigationController?.pushViewController(noticeViewController, animated: true)
    }
}

extension STMyPageNoticeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeTableViewCell") as! STMyPageNoticeCell
        cell.titleLabel.text = noticeList?[indexPath.row].title
        cell.timeLabel.text = noticeList?[indexPath.row].createDate
        cell.selectionStyle = .none
        return cell
    }
    
}

class STMyPageNoticeCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
}
