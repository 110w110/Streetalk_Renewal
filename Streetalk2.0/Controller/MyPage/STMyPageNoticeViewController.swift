//
//  STMyPageHelpViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/23.
//

import UIKit

class STMyPageNoticeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    private var noticeList: [PostList]?
    
    private let testTitleList: [String]? = ["[서비스공지] Streetalk 개인정보 처리방침 개정 안내 (2023.07.12)" ,"[공지] 23년 7월 3주차 정기점검 안내" ,"[안내]스트릿톡에 오신 것을 환영합니다."]
    private let testTimeList: [String]? = ["2023.07.12 수 01:00", "2023.07.12 수 01:00", "2023.07.12 수 00:00"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension STMyPageNoticeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        let postViewController = storyboard.instantiateViewController(withIdentifier: "postViewController") as! STPostViewController
        postViewController.title = "공지사항"
        postViewController.hidesBottomBarWhenPushed = true
        postViewController.postId = 0
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
}

extension STMyPageNoticeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testTitleList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeTableViewCell") as! STMyPageNoticeCell
        cell.titleLabel.text = testTitleList?[indexPath.row]
        cell.timeLabel.text = testTimeList?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}

class STMyPageNoticeCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
}
