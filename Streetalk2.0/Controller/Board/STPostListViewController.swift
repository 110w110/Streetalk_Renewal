//
//  STBoardListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STPostListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var searchPostList: [SearchPost] = []
    private var postList: [PostList] = []
    private let refreshControl = UIRefreshControl()
    private var favoriteButton: UIBarButtonItem?
    
    // 임시로 1번 게시판 할당, 차후에 게시판 선택 구현 후에 수정할 예정
    var boardId: Int? = 1
    var boardName: String?
    var favorite: Bool = false
    var listMode: ListMode = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        initialSetUI()
    }

}

extension STPostListViewController {
    
    private func initialSetUI() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        
        if listMode == .default {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), style: .plain, target: self, action: #selector(boardLike))
            favoriteButton = navigationItem.rightBarButtonItem
            
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
        } else {
            switch listMode {
            case .myPost:
                let request = GetMyPostListRequest()
                request.request(completion: { result in
                    switch result {
                    case let .success(data):
                        self.searchPostList = data
                    case let .failure(error):
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            case .myReply:
                let request = GetMyPostListRequest()
                request.request(completion: { result in
                    switch result {
                    case let .success(data):
                        self.searchPostList = data
                    case let .failure(error):
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            case .myLike:
                let request = GetMyLikesListRequest()
                request.request(completion: { result in
                    switch result {
                    case let .success(data):
                        self.searchPostList = data
                    case let .failure(error):
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            case .myScrap:
                let request = GetMyScrapsListRequest()
                request.request(completion: { result in
                    switch result {
                    case let .success(data):
                        self.searchPostList = data
                    case let .failure(error):
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            default:
                return
            }
        }
    }
    
    @objc private func refreshUI() {
        guard let id = boardId else { return }
        let request = GetPostListRequest(additionalInfo: "\(id)")
        request.request(completion: { result in
            switch result {
            case let .success(data):
                self.postList = data
            case let .failure(error):
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.rightBarButtonItem?.image = self.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
                self.refreshControl.endRefreshing()
            }
        })
        
    }
    
    @objc private func boardLike() {
        guard let id = boardId else { return }
        let request = LikeBoardRequest(additionalInfo: "/\(id)")
        request.request(completion: { result in
            switch result {
            case .success(let data):
                print(data)
                self.favorite = !self.favorite
                self.refreshUI()
            case .failure(let error):
                print(error)
            }
        })
    }
}

extension STPostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listMode == .default {
            return postList.count
        } else {
            return searchPostList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if listMode == .default {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postListTableViewCell", for: indexPath) as! STPostListTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = postList[indexPath.row].title
            cell.contentLabel.text = postList[indexPath.row].content
            cell.nickNameLabel.text = postList[indexPath.row].writer
            cell.timeLabel.text = postList[indexPath.row].lastTime?.toLastTimeString()
            cell.commentCount.text = postList[indexPath.row].replyCount?.toString()
            cell.likeCount.text = postList[indexPath.row].likeCount?.toString()
            cell.scrapCount.text = postList[indexPath.row].scrapCount?.toString()
            cell.postId = postList[indexPath.row].postId
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postListTableViewCell", for: indexPath) as! STPostListTableViewCell
            cell.selectionStyle = .none
            cell.titleLabel.text = searchPostList[indexPath.row].title
            cell.contentLabel.text = searchPostList[indexPath.row].content
            cell.nickNameLabel.text = searchPostList[indexPath.row].writer
            cell.timeLabel.text = searchPostList[indexPath.row].createdDate
            cell.commentCount.text = searchPostList[indexPath.row].replyCount?.toString()
            cell.likeCount.text = searchPostList[indexPath.row].likeCount?.toString()
            cell.scrapCount.text = searchPostList[indexPath.row].scrapCount?.toString()
            cell.postId = searchPostList[indexPath.row].id
            return cell
        }
    }
    
}

extension STPostListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "postViewController") as! STPostViewController
        postViewController.title = boardName
        postViewController.hidesBottomBarWhenPushed = true
        
        if listMode == .default {
            postViewController.postId = postList[indexPath.row].postId
        } else {
            postViewController.postId = searchPostList[indexPath.row].id
        }
        
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


enum ListMode {
    case `default`
    case myPost
    case myReply
    case myScrap
    case myLike
}
