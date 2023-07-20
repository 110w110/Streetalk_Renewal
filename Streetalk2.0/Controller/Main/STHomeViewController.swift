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
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    private var kTableHeaderHeight:CGFloat = 200
    private var homeInfo: HomeInfo?
    private var notice: Notice?
    
    // temp
    var imageList: [String]? = []
//    ["https://app-streetalk.s3.ap-northeast-2.amazonaws.com/8/42/1?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230718T051657Z&X-Amz-SignedHeaders=host&X-Amz-Expires=18000&X-Amz-Credential=AKIAUCID2AFMZ2JXZUJB%2F20230718%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=bfe2aa0d9889fb217d093c122b477e8f1cba2cbc8cccba55181c3353ff65a771","https://app-streetalk.s3.ap-northeast-2.amazonaws.com/8/42/2?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230718T051657Z&X-Amz-SignedHeaders=host&X-Amz-Expires=18000&X-Amz-Credential=AKIAUCID2AFMZ2JXZUJB%2F20230718%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=f4e8f2c12782d8e1225cddbd2d1432978e2a4e1b9dde8d90a10d8f1406918bcf","https://app-streetalk.s3.ap-northeast-2.amazonaws.com/8/42/3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230718T051657Z&X-Amz-SignedHeaders=host&X-Amz-Expires=17999&X-Amz-Credential=AKIAUCID2AFMZ2JXZUJB%2F20230718%2Fap-northeast-2%2Fs3%2Faws4_request&X-Amz-Signature=4be1dc369e72444fae35c02f14ccf6cda36ee26d1bdab9839e857fdc4013e94b"]
    
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

extension STHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 10
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
        return imageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCell
        
        if let image = imageList?[indexPath.row] {
            let url = URL(string: image)
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(
              with: url,
              placeholder: nil,
              options: [.transition(.fade(1.2))],
              completionHandler: nil
            )
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
            return 80 + ceil(CGFloat(self.homeInfo?.likeBoardList?.count ?? 0) / 2.5) * 50
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
        fetchHomeData()
    }
    
    private func fetchHomeData() {
        let request = HomeInfoRequest()
        request.request(completion: { result in
            switch result {
            case let .success(object):
                self.homeInfo = object
                
                let noticeRequest = NoticeRequest()
                noticeRequest.request(completion: { result in
                    switch result {
                    case let .success(data):
                        if data.count != 0 {
                            self.notice = data[0]
                        }
                    case let .failure(error):
                        print(error)
                    }
                    DispatchQueue.main.async { self.setUI() }
                })
                
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

class BannerCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
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
