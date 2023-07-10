//
//  STHomeViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/13.
//

import UIKit

class STHomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var homeInfo: HomeInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.fetchHomeData()
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
                DispatchQueue.main.async {
                    self.setUI()
                }
            case let .failure(error):
                print("Error: Decoding error \(error)")
            }
        })
    }
    
    private func setUI() {
        
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
        cell.backgroundColor = .clear
        
        return cell
    }
    
}

extension STHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - 20
        let height: CGFloat = collectionView.frame.height * 1.5
        return CGSize(width: width, height: height )
    }
    
}

class STHomeMainCollectionCell: UICollectionViewCell {
    
    @IBOutlet var notiView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var notiLabel: UILabel!
    
    @IBOutlet var hotPostSectionView: UIView!
    @IBOutlet var favoriteBoardSectionView: UIView!
    @IBOutlet var eventSectionView: UIView!
    
    @IBOutlet var sectionChoiceCollectionView: UICollectionView!
    @IBOutlet var postCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        notiView.setRoundedBorder(shadow: true)
        mainView.setRoundedBorder(shadow: true)
        notiLabel.textColor = .streetalkPink
        notiLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        
        hotPostSectionView.setRoundedBorder(shadow: true)
        favoriteBoardSectionView.setRoundedBorder(shadow: true)
        eventSectionView.setRoundedBorder(shadow: true)
    }
    
}

extension STHomeMainCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sectionChoiceCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath)
            cell.backgroundColor = .systemBackground
            
            return cell
            
        } else if collectionView == postCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionViewCell", for: indexPath)
            cell.backgroundColor = .systemBackground
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension STHomeMainCollectionCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == postCollectionView {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = collectionView.frame.height / 5
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
