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
    
    var isSubBoard: Bool = false
    var boardId: Int? = 1
    var boardName: String?
    var favorite: Bool = false
    var listMode: ListMode = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if isSubBoard {
            let tabbar = self.tabBarController as! STTabBarController
            tabbar.targetBoardID = boardId
        }
        
        initialSetUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData(id: boardId)
    }
    
}

extension STPostListViewController {
    
    private func initialSetUI() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        fetchData(id: boardId)
    }
    
    @objc private func refreshUI() {
        fetchData(id: boardId)
    }
    
    private func fetchData(id: Int?) {
        switch listMode {
        case .myPost:
            let request = URLSessionRequest<[SearchPost]>(uri: "/user/post", methods: .get)
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    self.searchPostList = data
                case let .failure(error):
                    print(error)
                    self.errorMessage(error: error, message: #function)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            })
        case .myReply:
            let request = URLSessionRequest<[SearchPost]>(uri: "/user/postMyReply", methods: .get)
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    self.searchPostList = data
                case let .failure(error):
                    print(error)
                    self.errorMessage(error: error, message: #function)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            })
        case .myLike:
            let request = URLSessionRequest<[SearchPost]>(uri: "/user/postLikes", methods: .get)
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    self.searchPostList = data
                case let .failure(error):
                    print(error)
                    self.errorMessage(error: error, message: #function)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            })
        case .myScrap:
            let request = URLSessionRequest<[SearchPost]>(uri: "/user/postScraps", methods: .get)
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    self.searchPostList = data
                case let .failure(error):
                    print(error)
                    self.errorMessage(error: error, message: #function)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            })
        default:
            guard let id = id else { return }
            let request = URLSessionRequest<BoardInfo>(uri: "/post/list/", methods: .get, additionalInfo: "\(id)")
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    self.postList = data.postList ?? []
                    self.favorite = data.like ?? false
                case let .failure(error):
                    print(error)
                    self.errorMessage(error: error, message: #function)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), style: .plain, target: self, action: #selector(self.boardLike))
                    self.favoriteButton = self.navigationItem.rightBarButtonItem
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
    
    @objc private func boardLike() {
        guard let id = boardId else { return }
        var method: HttpMethods = favorite ? .delete : .post
        let request = URLSessionRequest<String>(uri: "/boardLike", methods: method, additionalInfo: "/\(id)")
        request.request(completion: { result in
            switch result {
            case .success(let data):
                print(data)
                self.refreshUI()
            case .failure(let error):
                print(error)
                self.errorMessage(error: error, message: #function)
            }
        })
    }
}

extension STPostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listMode == .default {
            return max(1, postList.count)
        } else {
            return max(1, searchPostList.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postList.count == 0 && searchPostList.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postEmptyCell", for: indexPath) as! STPostEmptyCell
            cell.selectionStyle = .none
            return cell
        }
        if listMode == .default {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postListTableViewCell", for: indexPath) as! STPostListTableViewCell
            let writerName = postList[indexPath.row].isPrivate ?? false ? "익명" : postList[indexPath.row].writer
            cell.selectionStyle = .none
            cell.titleLabel.text = postList[indexPath.row].title
            cell.contentLabel.text = postList[indexPath.row].content
            cell.nickNameLabel.text = writerName
            cell.timeLabel.text = postList[indexPath.row].lastTime?.toLastTimeString()
            cell.likeImage.isHighlighted = postList[indexPath.row].postLike ?? false
            cell.scrapImage.isHighlighted = postList[indexPath.row].postScrap ?? false
            cell.commentCount.text = postList[indexPath.row].replyCount?.toString()
            cell.likeCount.text = postList[indexPath.row].likeCount?.toString()
            cell.scrapCount.text = postList[indexPath.row].scrapCount?.toString()
            cell.postId = postList[indexPath.row].postId
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postListTableViewCell", for: indexPath) as! STPostListTableViewCell
            let writerName = searchPostList[indexPath.row].isPrivate ?? false ? "익명" : searchPostList[indexPath.row].writer
            cell.selectionStyle = .none
            cell.titleLabel.text = searchPostList[indexPath.row].title
            cell.contentLabel.text = searchPostList[indexPath.row].content
            cell.nickNameLabel.text = writerName
            cell.timeLabel.text = searchPostList[indexPath.row].createdDate
            cell.likeImage.isHighlighted = searchPostList[indexPath.row].postLike ?? false
            cell.scrapImage.isHighlighted = searchPostList[indexPath.row].postScrap ?? false
            cell.commentCount.text = searchPostList[indexPath.row].replyCount?.toString()
            cell.likeCount.text = searchPostList[indexPath.row].likeCount?.toString()
            cell.scrapCount.text = searchPostList[indexPath.row].scrapCount?.toString()
            cell.postId = searchPostList[indexPath.row].id
            cell.cellBackground.layer.borderColor = UIColor.systemGray5.cgColor
            return cell
        }
    }
    
}

extension STPostListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if postList.count == 0 && searchPostList.count == 0 {
            return
        }
        
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
            let request = URLSessionRequest<BoardInfo>(uri: "/post/list/", methods: .get, additionalInfo: "\(id)/\(lastId)")
            request.request(completion: { result in
                switch result {
                case let .success(data):
                    self.postList += data.postList ?? []
                case let .failure(error):
                    print(error)
                    self.errorMessage(error: error, message: #function)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
}

class STPostEmptyCell: UITableViewCell {
    
}

enum ListMode {
    case `default`
    case myPost
    case myReply
    case myScrap
    case myLike
}
