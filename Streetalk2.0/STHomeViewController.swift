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
        presentJoinViewController()
    }
    
    private func presentJoinViewController() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            DispatchQueue.main.async {
                let joinStoryboard = UIStoryboard(name: "Join", bundle: nil)
                let joinViewController = joinStoryboard.instantiateViewController(withIdentifier: "joinViewController")
//                self.navigationController?.pushViewController(VC, animated: true)
                joinViewController.modalPresentationStyle = .overFullScreen
                joinViewController.modalTransitionStyle = .crossDissolve
                self.present(joinViewController, animated: true, completion: nil)
            }
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as UICollectionViewCell
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
