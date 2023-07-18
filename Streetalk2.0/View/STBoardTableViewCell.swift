//
//  STBoardTableViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/11.
//

import UIKit

class STBoardTableViewCell: UITableViewCell {
    
    @IBOutlet var sectionCollectionView: UICollectionView!
    @IBOutlet var boardCollectionView: UICollectionView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var emptyLabel: UILabel!
    
    var homeInfo: HomeInfo?
    var navigation: UINavigationController?
    
    private let section = ["내 지역", "내 업종", "실시간"]
    private var sectionSelection: BoardSelection = .myLocal
    private var posts: [HomePost]? = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        boardCollectionView.dataSource = self
        boardCollectionView.delegate = self
        
        setData()
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
    
    func setData() {
        switch sectionSelection {
        case .newPost:
            posts = homeInfo?.newPosts
        case .myLocal:
            posts = homeInfo?.myLocalPosts
        case .myIndustry:
            posts = homeInfo?.myIndustryPosts
        }
        
        if posts == nil || posts?.count == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
    }
}

fileprivate enum BoardSelection {
    case newPost
    case myLocal
    case myIndustry
}

extension STBoardTableViewCell: UICollectionViewDataSource {
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
            cell.commentCountLabel.text = "\( posts?[indexPath.row].replyCount ?? 0)"
            return cell
        }
    }
    
}

extension STBoardTableViewCell: UICollectionViewDelegate {

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
            
            boardCollectionView.reloadData()
            
            if posts == nil || posts?.count == 0 {
                self.emptyLabel.isHidden = false
            } else {
                self.emptyLabel.isHidden = true
            }
        } else if collectionView == boardCollectionView {
            let storyboard = UIStoryboard(name: "Board", bundle: nil)
            let postController = storyboard.instantiateViewController(identifier: "postViewController") as! STPostViewController
            switch self.sectionSelection {
            case .myLocal:
                postController.postId = homeInfo?.myLocalPosts?[indexPath.row].postId
                postController.title = "내 지역 게시판"
            case .myIndustry:
                postController.postId = homeInfo?.myIndustryPosts?[indexPath.row].postId
                postController.title = "내 업종 게시판"
            case .newPost:
                postController.postId = homeInfo?.newPosts?[indexPath.row].postId
                postController.title = "새 글 게시판"
            }
            postController.hidesBottomBarWhenPushed = true
            self.navigation?.pushViewController(postController, animated: true)
                
        }
    }
    
}

extension STBoardTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == sectionCollectionView {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
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
        return 30
    }
}
