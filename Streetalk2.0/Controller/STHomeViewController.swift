//
//  STHomeViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/13.
//

import UIKit

class STHomeViewController: UIViewController, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        homeNotiStackViewBackground.setRoundedBorder()
//        homeNotiStackViewBackground.setRoundedBorder()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! STHomeMainCollectionCell
        cell.backgroundColor = .systemBackground
        cell.layer.cornerRadius = 10.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeaderCell", for: indexPath) as? STCollectionReusableView else {
                    fatalError("Invalid view type")
            }
            
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
}

class STHomeMainCollectionCell: UICollectionViewCell {
    @IBOutlet var notiView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var notiLabel: UILabel!
    
    @IBOutlet var hotPostSectionView: UIView!
    @IBOutlet var favoriteBoardSectionView: UIView!
    @IBOutlet var eventSectionView: UIView!
    
    override func awakeFromNib() {
        notiView.setRoundedBorder(shadow: true)
        mainView.setRoundedBorder(shadow: true)
        notiLabel.textColor = .streetalkPink
        notiLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        hotPostSectionView.setRoundedBorder(shadow: true)
        favoriteBoardSectionView.setRoundedBorder(shadow: true)
        eventSectionView.setRoundedBorder(shadow: true)
    }
}

