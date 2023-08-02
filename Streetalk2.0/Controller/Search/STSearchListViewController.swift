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
    
    private var postList: [SearchPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func searchTextFieldEditing(_ sender: Any) {
        guard let text = self.searchTextField.text else { return }
        
        DispatchQueue.global().async {
            if text.isEmpty {
                self.postList = []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
            
            let request = URLSessionRequest<[SearchPost]>(uri: "/searchPost/", methods: .get, additionalInfo: text)
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    print(data)
                    self.postList = data
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
    
}

extension STSearchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, postList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postList.count <= indexPath.row {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "searchEmptyCell") as! STSearchEmptyCell
            cell.selectionStyle = .none
            return cell
        }
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
        if postList.count <= indexPath.row {
            return
        }
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        let postViewController = storyboard.instantiateViewController(withIdentifier: "postViewController") as! STPostViewController
        postViewController.title = "지역 게시판"
        postViewController.hidesBottomBarWhenPushed = true
        postViewController.postId = postList[indexPath.row].id
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if postList.count == 0 {
            return tableView.frame.height - 50
        }
        return 180
    }
    
}

class STSearchEmptyCell: UITableViewCell {
    
}
