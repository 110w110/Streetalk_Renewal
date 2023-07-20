//
//  STSearchListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import UIKit

class STSearchListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var emptyImage: UIImageView!
    
    private var postList: [SearchPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    @IBAction func searchTextFieldEditing(_ sender: Any) {
        guard let text = self.searchTextField.text else { return }
        
        if text.isEmpty {
            postList = []
            self.tableView.reloadData()
        }
        
        let request = SearchRequest(additionalInfo: text)
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                self.postList = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.postList.isEmpty {
                        self.emptyImage.isHidden = false
                    } else {
                        self.emptyImage.isHidden = true
                    }
                }
            case let .failure(error):
                print(error)
                self.errorMessage(error: error, message: #function)
            }
        })
    }
    
}


extension STSearchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchPostTableViewCell", for: indexPath) as! STSearchPostTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = postList[indexPath.row].title
        cell.contentLabel.text = postList[indexPath.row].content
        cell.nickNameLabel.text = postList[indexPath.row].writer
        cell.timeLabel.text = postList[indexPath.row].createdDate
        cell.likeImage.isHighlighted = postList[indexPath.row].postLike ?? false
        cell.scrapImage.isHighlighted = postList[indexPath.row].postScrap ?? false
        cell.commentCount.text = postList[indexPath.row].replyCount?.toString()
        cell.likeCount.text = postList[indexPath.row].likeCount?.toString()
        cell.scrapCount.text = postList[indexPath.row].scrapCount?.toString()
        return cell
    }
    
}

extension STSearchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        let postViewController = storyboard.instantiateViewController(withIdentifier: "postViewController") as! STPostViewController
        postViewController.title = "지역 게시판"
        postViewController.hidesBottomBarWhenPushed = true
        postViewController.postId = postList[indexPath.row].id
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
}
