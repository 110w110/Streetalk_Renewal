//
//  STBoardListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STPostListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var postList: [PostList] = []
    
    // 임시로 1번 게시판 할당, 차후에 게시판 선택 구현 후에 수정할 예정
    var boardId: Int? = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let id = boardId else { return }
        let request = GetPostListRequest(additionalInfo: "\(id)")
        request.request(completion: { result in
            switch result {
            case let .success(data):
                self.postList += data
            case let .failure(error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }

}

extension STPostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! STPostTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = postList[indexPath.row].title
        cell.contentLabel.text = postList[indexPath.row].content
        cell.nickNameLabel.text = postList[indexPath.row].writer
        cell.timeLabel.text = String(postList[indexPath.row].lastTime ?? 0)
        return cell
    }
    
}

extension STPostListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "postViewController") as! STPostViewController
        postViewController.title = "지역 게시판"
        postViewController.hidesBottomBarWhenPushed = true
        postViewController.postId = postList[indexPath.row].postId
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y + 1) >= (self.tableView.contentSize.height - self.tableView.frame.size.height) {
            guard let id = boardId, let lastId = self.postList.last?.postId else { return }
            let request = GetPostListRequest(additionalInfo: "\(id)/\(lastId)")
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    self.postList += data
                case let .failure(error):
                    print(error)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
}


