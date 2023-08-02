//
//  STPostListTableViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/16.
//

import UIKit

class STPostListTableViewCell: UITableViewCell {

    @IBOutlet var cellBackground: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var postTimeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var bottomStackView: UIStackView!
    @IBOutlet var primaryNickNameStackView: UIStackView!
    @IBOutlet var secondaryNickNameStackView: UIStackView!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var commentCount: UILabel!
    @IBOutlet var scrapCount: UILabel!

    @IBOutlet var likeView: UIStackView!
    @IBOutlet var scrapView: UIStackView!
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var scrapImage: UIImageView!
//
//    @IBOutlet var imageCollectionView: UICollectionView!
    
    var postId: Int?
    var like: Int?
    var scrap: Int?
    var imageUrls: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        imageCollectionView.dataSource = self
        
        cellBackground.setRoundedBorder()
        bottomStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 15, right: 10)
        bottomStackView.isLayoutMarginsRelativeArrangement = true
        
        let like = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeView.isUserInteractionEnabled = true
        likeView.addGestureRecognizer(like)
        
        let scrap = UITapGestureRecognizer(target: self, action: #selector(scrapTapped))
        scrapView.isUserInteractionEnabled = true
        scrapView.addGestureRecognizer(scrap)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension STPostListTableViewCell {
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        guard let id = postId else { return }
        let request = URLSessionRequest<String>(uri: "/postLike", methods: .put, additionalInfo: "/\(id)")
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                
                guard let id = self.postId else { return }
                let postRequest = GetPostRequest(additionalInfo: "\(id)")
                postRequest.request(completion: { result in
                    switch result {
                    case let .success(data):
                        self.like = data.likeCount
                        self.scrap = data.scrapCount
                    case let .failure(error):
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.likeCount.text = self.like?.toString()
                        self.scrapCount.text = self.scrap?.toString()
                        self.likeImage.isHighlighted = !self.likeImage.isHighlighted
                    }
                })
            case let .failure(error):
                print(error)
            }
        })
    }
    
    @objc func scrapTapped(sender: UITapGestureRecognizer) {
        guard let id = postId else { return }
        let request = URLSessionRequest<String>(uri: "/postScrap", methods: .put, additionalInfo: "/\(id)")
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                
                guard let id = self.postId else { return }
                let postRequest = GetPostRequest(additionalInfo: "\(id)")
                postRequest.request(completion: { result in
                    switch result {
                    case let .success(data):
                        self.like = data.likeCount
                        self.scrap = data.scrapCount
                    case let .failure(error):
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.likeCount.text = self.like?.toString()
                        self.scrapCount.text = self.scrap?.toString()
                        self.scrapImage.isHighlighted = !self.scrapImage.isHighlighted
                    }
                })
            case let .failure(error):
                print(error)
            }
        })
    }
}

//extension STPostListTableViewCell: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageUrls?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postImageCell", for: indexPath) as! PostImageCell
//
//        return cell
//    }
//
//}
//
//class PostImageCell: UICollectionViewCell {
////    @IBOutlet var imageView: UIImageView!
//}
