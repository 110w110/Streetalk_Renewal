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
    
    
    private var kTableHeaderHeight:CGFloat = 200
    
    var homeInfo: HomeInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        setStretchableHeaderView()
        updateHeaderView()
        
        self.fetchHomeData()
    }
    
}

extension STHomeViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}

extension STHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeTableViewCell", for: indexPath) as! NoticeTableViewCell
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "boardTableViewCell", for: indexPath) as! BoardTableViewCell
            cell.selectionStyle = .none
            cell.homeInfo = self.homeInfo
            cell.boardCollectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 60
        default:
            return 360
        }
    }
}

extension STHomeViewController {
    
    private func fetchHomeData() {
        let request = HomeInfoRequest()
        request.request(completion: { result in
            switch result {
            case let .success(object):
                dump(object)
                self.homeInfo = object
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
    }
    
    func setStretchableHeaderView() {
        stretchableView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(stretchableView)
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
    }
    
    func updateHeaderView() {
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

    let view1: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        return v
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpUI() {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
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

class BoardTableViewCell: UITableViewCell {
    
    @IBOutlet var sectionCollectionView: UICollectionView!
    @IBOutlet var boardCollectionView: UICollectionView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var emptyLabel: UILabel!
    
    var homeInfo: HomeInfo?
    
    private let section = ["내 지역", "내 업종", "실시간"]
    private var sectionSelection: BoardSelection = .myLocal
    private var posts: [HomePost]? = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        boardCollectionView.dataSource = self
        boardCollectionView.delegate = self
        
        posts = homeInfo?.myLocalPosts
        
        if posts == nil || posts?.count == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        contentView.setRoundedBorder()
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

fileprivate enum BoardSelection {
    case newPost
    case myLocal
    case myIndustry
}

extension BoardTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sectionCollectionView {
            return 3
        }
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sectionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionCollectionViewCell
            cell.label.text = section[indexPath.row]
            cell.selectionView.backgroundColor = .streetalkPink
            
            if indexPath.row == 0 {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boardCollectionViewCell", for: indexPath) as! BoardCollectionViewCell
            cell.contentsLabel.text = posts?[indexPath.row].title
            cell.infoLabel.text = posts?[indexPath.row].location
            cell.commentCountLabel.text = "\(String(describing: posts?[indexPath.row].replyCount))"
            return cell
        }
    }
    
}

extension BoardTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sectionCollectionView {
            switch indexPath.row {
            case 0:
                self.sectionSelection = .myLocal
                self.posts = self.homeInfo?.myLocalPosts
            case 1:
                self.sectionSelection = .myIndustry
                self.posts = self.homeInfo?.myIndustryPosts
            default:
                self.sectionSelection = .newPost
                self.posts = self.homeInfo?.newPosts
            }
            // 보이는 게시글 바꾸기
            boardCollectionView.reloadData()
            
            if posts == nil || posts?.count == 0 {
                self.emptyLabel.isHidden = false
            } else {
                self.emptyLabel.isHidden = true
            }
        } else if collectionView == boardCollectionView {
            
        }
    }
    
}

extension BoardTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == sectionCollectionView {
            return UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sectionCollectionView {
            let width: CGFloat = collectionView.frame.width / 3
            let height: CGFloat = collectionView.frame.height
            return CGSize(width: width, height: height)
        } else {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = collectionView.frame.height / 5
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class SectionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var selectionView: UIView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectionView.isHidden = false
            } else {
                selectionView.isHidden = true
            }
        }
    }
}

class BoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
}

//extension STHomeViewController {
//
//    private func fetchHomeData() {
//        let request = HomeInfoRequest()
//        request.request(completion: { result in
//            switch result {
//            case let .success(object):
//                dump(object)
//                self.homeInfo = object
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//
//                }
//            case let .failure(error):
//                print("Error: Decoding error \(error)")
//            }
//        })
//    }
//
//    private func setUI() {
//    }
//}

//extension STHomeViewController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        switch kind {
//        case UICollectionView.elementKindSectionHeader:
//            guard
//                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeaderCell", for: indexPath) as? STCollectionReusableView else {
//                    fatalError("Invalid view type")
//            }
//
//            headerView.nickNameLabel.text = homeInfo?.userName
//            headerView.locationLabel.text = homeInfo?.location
//            headerView.industryLabel.text = homeInfo?.industry
//            return headerView
//        default:
//            assert(false, "Invalid element type")
//        }
//    }
//
//}
//
//extension STHomeViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! STHomeMainCollectionCell
//        cell.backgroundColor = .clear
//        cell.homeInfo = self.homeInfo
//        return cell
//    }
//
//}
//
//extension STHomeViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width: CGFloat = collectionView.frame.width - 20
//        let height: CGFloat = collectionView.frame.height * 1.5
//        return CGSize(width: width, height: height )
//    }
//
//}
//
//class STHomeMainCollectionCell: UICollectionViewCell {
//
//    @IBOutlet var notiView: UIView!
//    @IBOutlet var mainView: UIView!
//    @IBOutlet var notiLabel: UILabel!
//
//    @IBOutlet var hotPostSectionView: UIView!
//    @IBOutlet var favoriteBoardSectionView: UIView!
//    @IBOutlet var eventSectionView: UIView!
//
//    @IBOutlet var sectionChoiceCollectionView: UICollectionView!
//    @IBOutlet var postCollectionView: UICollectionView!
//
//    var homeInfo: HomeInfo?
//    private var boardSelection: BoardSelection = .newPost
//
//    override func awakeFromNib() {
//        notiView.setRoundedBorder(shadow: true)
//        mainView.setRoundedBorder(shadow: true)
//        notiLabel.textColor = .streetalkPink
//        notiLabel.font = UIFont.boldSystemFont(ofSize: 16)
//
//        postCollectionView.delegate = self
//        postCollectionView.dataSource = self
//
//        hotPostSectionView.setRoundedBorder(shadow: true)
//        favoriteBoardSectionView.setRoundedBorder(shadow: true)
//        eventSectionView.setRoundedBorder(shadow: true)
//
//        sectionChoiceCollectionView.reloadData()
//    }
//
//}
//
//fileprivate enum BoardSelection {
//    case newPost
//    case myLocal
//    case myIndustry
//}
//
//extension STHomeMainCollectionCell: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == sectionChoiceCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath)
//            cell.backgroundColor = .systemBackground
//
//            return cell
//
//        } else if collectionView == postCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionViewCell", for: indexPath) as! STPostCollectionCell
//            cell.backgroundColor = .systemBackground
//
//            switch boardSelection {
//            case .myLocal:
//                cell.contentsLabel.text = homeInfo?.myLocalPosts?[indexPath.row].title
//            case .myIndustry:
//                cell.contentsLabel.text = homeInfo?.myIndustryPosts?[indexPath.row].title
//            case .newPost:
//                cell.contentsLabel.text = homeInfo?.newPosts?[indexPath.row].title
//            }
//
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//
//}
//
//extension STHomeMainCollectionCell: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == postCollectionView {
//            let width: CGFloat = collectionView.frame.width
//            let height: CGFloat = collectionView.frame.height / 5
//            return CGSize(width: width, height: height)
//        }
//        return CGSize(width: 0, height: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}
//
//class STPostCollectionCell: UICollectionViewCell {
//    @IBOutlet var contentsLabel: UILabel!
//    @IBOutlet var infoLabel: UILabel!
//    @IBOutlet var commentCountLabel: UILabel!
//
//    override func awakeFromNib() {
//
//    }
//}
