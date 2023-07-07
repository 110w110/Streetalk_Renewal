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
    
    let debugBoardTitles = ["인기 게시글", "자유 게시판", "지역 게시판", "업종 게시판"]
    let debugSubBoardTitles = ["주식 게시판", "해외축구 게시판", "게임 게시판", "자전거 게시판"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainBoardListCollectionView.dataSource = self
        mainBoardListCollectionView.delegate = self
        subBoardListCollectionView.dataSource = self
        subBoardListCollectionView.delegate = self
        
        setUI()
    }
    
    func setUI() {
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        myBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
        mainBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
        subBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
    }

}

extension STBoardListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                label.text = debugBoardTitles[indexPath.row]
            } else {
                label.text = debugSubBoardTitles[indexPath.row]
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

