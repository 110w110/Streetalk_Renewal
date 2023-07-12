//
//  STHomeViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/13.
//

import UIKit

class STHomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var stretchableView: UIView!
    
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var industryLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    private var kTableHeaderHeight:CGFloat = 200
    private var homeInfo: HomeInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        setStretchableHeaderView()
        updateHeaderView()
        initialSetUI()
    }
    
}

extension STHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 60
        case 2:
            return 200
        default:
            return 360
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
        fetchHomeData()
    }
    
    private func fetchHomeData() {
        let request = HomeInfoRequest()
        request.request(completion: { result in
            switch result {
            case let .success(object):
                self.homeInfo = object
                
                // for test
                self.homeInfo?.likeBoardList?.append(BoardLiked(boardName: "재밌는 게시판", boardId: 1))
                
                DispatchQueue.main.async { self.setUI() }
            case let .failure(error):
                print("Error: Decoding error \(error)")
            }
        })
    }

    private func setUI() {
        tableView.reloadData()
        
        nickNameLabel.text = homeInfo?.userName
        locationLabel.text = homeInfo?.location
        industryLabel.text = homeInfo?.industry
        
        self.refreshControl.endRefreshing()
        
//        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? STBoardTableViewCell {
//            cell.homeInfo = self.homeInfo
//            cell.boardCollectionView.reloadData()
//        }
//        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? STLikedBoardTableViewCell {
//            cell.homeInfo = self.homeInfo
//            cell.likedBoardCollectionView.reloadData()
//        }
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
}

class StretchyTableViewCell: UITableViewCell {

    private let view1: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        return v
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setUI() {
        self.backgroundColor = .white
        
        view1.layer.cornerRadius = 10.0
        self.addSubview(view1)
        
        view1.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        view1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        view1.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        view1.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true

    }
}

class NoticeTableViewCell: UITableViewCell {
    
    @IBOutlet var stackView: UIStackView!
    
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
