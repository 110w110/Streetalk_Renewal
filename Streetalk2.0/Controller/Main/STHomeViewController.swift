//
//  STHomeViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/13.
//

import UIKit

class STHomeViewController: UIViewController {
    
    @IBOutlet var userInfoView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var stretchableView: UIView!
    
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var industryLabel: UILabel!
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    private var kTableHeaderHeight:CGFloat = 200
    private var homeInfo: HomeInfo?
    private var notice: Notice?
    private var noticeList: [Notice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        setStretchableHeaderView()
        updateHeaderView()
        initialSetUI()
    }
    
}

extension STHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            guard let bannerList = homeInfo?.bannerList else { return }
            
            if bannerList[indexPath.row].notice ?? false {
                let noticeId = bannerList[indexPath.row].contentId ?? 0
                showNotice(by: noticeId)
            } else {
                let postId = bannerList[indexPath.row].contentId ?? 0
                showPost(id: postId)
            }
        }
    }
}

extension STHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.layoutIfNeeded()
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1000
    }
}

extension STHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeInfo?.bannerList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCell
        cell.LargeLabel.text = homeInfo?.bannerList?[indexPath.row].title
        if homeInfo?.bannerList?.count ?? 0 > indexPath.row {
            cell.SmallLabel.text = homeInfo?.bannerList?[indexPath.row].content
        }
        return cell
    }
    
}

extension STHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 60
        case 2:
            if self.self.homeInfo?.likeBoardList?.count == nil || self.homeInfo?.likeBoardList?.count == 0 {
                return 200
            }
            return 80 + ceil(CGFloat(self.homeInfo?.likeBoardList?.count ?? 0) / 2) * 40
        default:
            return 420
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: "myPageNoticeViewController") as! STMyPageNoticeViewController
            viewController.title = "공지사항"
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension STHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeTableViewCell", for: indexPath) as! NoticeTableViewCell
            cell.selectionStyle = .none
            cell.noticeLabel.text = notice?.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "boardTableViewCell", for: indexPath) as! STBoardTableViewCell
            cell.selectionStyle = .none
            cell.homeInfo = self.homeInfo
            cell.navigation = self.navigationController
            cell.boardCollectionView.reloadData()
            cell.setData()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "likedBoardTableViewCell", for: indexPath) as! STLikedBoardTableViewCell
            cell.selectionStyle = .none
            cell.homeInfo = self.homeInfo
            cell.navigation = self.navigationController
            cell.likedBoardCollectionView.reloadData()
            cell.setData()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "boardTableViewCell", for: indexPath) as! STBoardTableViewCell
            cell.selectionStyle = .none
            cell.homeInfo = self.homeInfo
            cell.navigation = self.navigationController
            cell.boardCollectionView.reloadData()
            return cell
        }
    }
    
}

extension STHomeViewController {
    
    private func initialSetUI() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        
        stretchableView?.translatesAutoresizingMaskIntoConstraints = false
        stretchableView?.topAnchor.constraint(equalTo: self.userInfoView.bottomAnchor).isActive = true
        stretchableView?.bottomAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        stretchableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stretchableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        fetchHomeData()
    }
    
    private func fetchHomeData() {
        let request = URLSessionRequest<HomeInfo>(uri: "/home", methods: .get)
        request.request(completion: { result in
            switch result {
            case let .success(object):
                self.homeInfo = object
                
                let noticeRequest = URLSessionRequest<[Notice]>(uri: "/user/notice", methods: .get)
                noticeRequest.request(completion: { result in
                    switch result {
                    case let .success(data):
                        if data.count != 0 {
                            self.notice = data[0]
                        }
                    case let .failure(error):
                        print(error)
                        self.errorMessage(error: error, message: #function)
                    }
                    DispatchQueue.main.async { self.setUI() }
                })
                
                self.fetchNotice()
                
            case let .failure(error):
                print("Error: Decoding error \(error)")
            }
        })
    }

    private func setUI() {
        tableView.reloadData()
        bannerCollectionView.reloadData()
        
        nickNameLabel.text = homeInfo?.userName
        locationLabel.text = homeInfo?.location
        industryLabel.text = homeInfo?.industry
        
        self.refreshControl.endRefreshing()
    }
    
    @objc private func refreshUI() {
        print("refresh")
        fetchHomeData()
    }
    
    private func setStretchableHeaderView() {
        stretchableView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(stretchableView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
    }
    
    private func updateHeaderView() {
       var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
       if tableView.contentOffset.y < -kTableHeaderHeight {
           headerRect.origin.y = tableView.contentOffset.y
           headerRect.size.height = -tableView.contentOffset.y
       }
        stretchableView.frame = headerRect
   }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
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
    
    private func showNotice(by: Int) {
        guard let noticeList = noticeList else { return }
        for notice in noticeList {
            if let id = notice.id, by == id {
                let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
                let noticeViewController = storyboard.instantiateViewController(withIdentifier: "noticeDetailViewController") as! STNoticeDetailViewController
                noticeViewController.title = "공지사항"
                noticeViewController.notice = notice
                self.navigationController?.pushViewController(noticeViewController, animated: true)
            }
        }
    }
    
    private func showPost(id: Int) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        let postViewController = storyboard.instantiateViewController(withIdentifier: "postViewController") as! STPostViewController
        postViewController.postId = id
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
}

class StretchyTableViewCell: UITableViewCell {
    
}

class BannerCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var LargeLabel: UILabel!
    @IBOutlet var SmallLabel: UILabel!
}

class NoticeTableViewCell: UITableViewCell {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var noticeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        contentView.setRoundedBorder()
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


class SectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var selectionView: UIView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectionView.alpha = 1.0
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectionView.alpha = 0.0
                })
            }
        }
    }
}

class BoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
}

class LikedBoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var star: UIImageView!
    @IBOutlet var boardLabel: UILabel!
}
