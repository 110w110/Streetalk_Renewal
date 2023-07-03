//
//  STHomeViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/13.
//

import UIKit

class STHomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let u = UserInfoRequest()
        u.request(completion: { result in
            switch result {
            case let .success(object):
                dump(object)
            case let .failure(error):
                print("Error: Decoding error \(error)")
            }
        })
    }
    
}

extension STHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
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

extension STHomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! STHomeMainCollectionCell
        cell.backgroundColor = .systemBackground
        
        return cell
    }
    
}

extension STHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
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

