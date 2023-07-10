//
//  STLikedBoardTableViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/11.
//

import UIKit

class STLikedBoardTableViewCell: UITableViewCell {
    
    @IBOutlet var likedBoardCollectionView: UICollectionView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var emptyLabel: UILabel!
    
    // for test
    private let debugLikedBoardList: [BoardLiked] = [BoardLiked(boardName: "재밌는 게시판", boardId: 1),BoardLiked(boardName: "무서운 게시판", boardId: 2),BoardLiked(boardName: "침하하 게시판", boardId: 3),]
    
    var homeInfo: HomeInfo?
    var navigation: UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likedBoardCollectionView.dataSource = self
        likedBoardCollectionView.delegate = self
        
//        if homeInfo?.likeBoardList == nil || homeInfo?.likeBoardList?.count == 0 {
//            self.emptyLabel.isHidden = false
//        } else {
//            self.emptyLabel.isHidden = true
//        }
        if debugLikedBoardList.count == 0 {
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

extension STLikedBoardTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return homeInfo?.likeBoardList?.count ?? 0
        return self.debugLikedBoardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedBoardCollectionViewCell", for: indexPath) as! LikedBoardCollectionViewCell
//        cell.boardLabel.text = homeInfo?.likeBoardList?[indexPath.row].boardName
        cell.boardLabel.text = self.debugLikedBoardList[indexPath.row].boardName
//        cell.contentsLabel.text = posts?[indexPath.row].title
//        cell.infoLabel.text = posts?[indexPath.row].location
//        cell.commentCountLabel.text = "\( posts?[indexPath.row].replyCount ?? 0)"
        return cell
    }
    
}

extension STLikedBoardTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Board", bundle: nil)
//        let postController = storyboard.instantiateViewController(identifier: "postViewController") as! STPostViewController
//        switch self.sectionSelection {
//        case .myLocal:
//            postController.postId = homeInfo?.myLocalPosts?[indexPath.row].postId
//        case .myIndustry:
//            postController.postId = homeInfo?.myIndustryPosts?[indexPath.row].postId
//        case .newPost:
//            postController.postId = homeInfo?.newPosts?[indexPath.row].postId
//        }
////            postController.title = "지역 게시판"
//        postController.hidesBottomBarWhenPushed = true
//        self.navigation?.pushViewController(postController, animated: true)
    }
    
}

extension STLikedBoardTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2
        let height: CGFloat = collectionView.frame.height / ceil(CGFloat(self.debugLikedBoardList.count) / (2.0))
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
