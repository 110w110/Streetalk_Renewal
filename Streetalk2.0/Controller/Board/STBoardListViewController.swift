//
//  STBoardListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STBoardListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var postList: [PostList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension STBoardListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! STPostTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
}

extension STBoardListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indexPath에 따라 정보 넘겨야함
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "postViewController") as! STPostViewController
        postViewController.title = "지역 게시판"
        postViewController.hidesBottomBarWhenPushed = true
        postViewController.postId = postList[indexPath.row].postId
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
}


