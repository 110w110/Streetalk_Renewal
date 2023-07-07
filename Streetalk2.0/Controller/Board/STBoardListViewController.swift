//
//  STBoardListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/07.
//

import UIKit

class STBoardListViewController: UIViewController {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet var myBoardListCollectionView: UICollectionView!
    @IBOutlet var mainBoardListCollectionView: UICollectionView!
    @IBOutlet var subBoardListCollectionView: UICollectionView!
    
    let myBoardImageList = [UIImage(named: "MyPost"), UIImage(named: "MyComment"), UIImage(named: "MyLike"), UIImage(named: "MyScrap")]
    let debugMyBoardTitles = ["내 게시글", "내 댓글", "추천한 게시글", "내 스크랩"]
    let debugBoardTitles = ["인기 게시글", "자유 게시판", "지역 게시판", "업종 게시판"]
    let debugSubBoardTitles = ["주식 게시판", "해외축구 게시판", "게임 게시판", "자전거 게시판"]
    
    private var mainBoardList: [Board] = []
    private var subBoardList: [Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBoardListCollectionView.dataSource = self
        myBoardListCollectionView.delegate = self
        mainBoardListCollectionView.dataSource = self
        mainBoardListCollectionView.delegate = self
        subBoardListCollectionView.dataSource = self
        subBoardListCollectionView.delegate = self
        
        getBoardList()
        setUI()
    }
    
    func setUI() {
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        myBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
        mainBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
        subBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
    }

    func getBoardList() {
        let request = BoardListRequest()
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                for board in data {
                    if board.category == "main" {
                        self.mainBoardList.append(board)
                    } else if board.category == "sub" {
                        self.subBoardList.append(board)
                    }
                    
                    DispatchQueue.main.async {
                        self.mainBoardListCollectionView.reloadData()
                        self.subBoardListCollectionView.reloadData()
                        self.myBoardListCollectionView.reloadData()
                    }
                }
            case let .failure(error):
                print(error)
            }
        })
    }
}

extension STBoardListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainBoardListCollectionView {
            return min(4, mainBoardList.count)
        } else if collectionView == subBoardListCollectionView {
            return min(4, subBoardList.count)
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == myBoardListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myBoardListCell", for: indexPath)
            
            let imageView = {
                let view = UIImageView(image: myBoardImageList[indexPath.row]?.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)))
                view.contentMode = .scaleAspectFit
                return view
            }()
            
            let label = {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                label.text = debugMyBoardTitles[indexPath.row]
                label.textAlignment = .center
                return label
            }()
            
            cell.addSubview(imageView)
            cell.addSubview(label)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0).isActive = true
            imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true
            imageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0).isActive = true
            label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true
            label.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
            label.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            return cell
        }
        
        let cell = {
            if collectionView == mainBoardListCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boardCollectionViewCell", for: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subBoardCollectionViewCell", for: indexPath)
                return cell
            }
        }()
        
        let label = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            if collectionView == mainBoardListCollectionView {
                label.text = mainBoardList[indexPath.row].boardName
            } else if collectionView == subBoardListCollectionView {
                label.text = subBoardList[indexPath.row].boardName
            }
            
            return label
        }()
        
        cell.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        
        return cell
    }
    
}

extension STBoardListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainBoardListCollectionView || collectionView == subBoardListCollectionView {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = collectionView.frame.height / 4
            return CGSize(width: width, height: height )
        } else if collectionView == myBoardListCollectionView {
            let width: CGFloat = collectionView.frame.width / 4
            let height: CGFloat = collectionView.frame.height - 20
            return CGSize(width: width, height: height )
        }
        return CGSize(width: 0.0, height: 0.0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
