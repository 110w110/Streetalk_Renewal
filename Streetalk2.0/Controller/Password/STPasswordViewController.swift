//
//  STPasswordViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/13.
//

import UIKit

class STPasswordViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    @IBOutlet var PrimaryLabel: UILabel!
    @IBOutlet var SecondaryLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var mode: passwordMode = .set
    
    private let realNumber: String = Foundation.UserDefaults.standard.string(forKey: "localPassword") ?? ""
    
//    UserDefaults.standard.set(self.token, forKey: "localPassword")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
//        textField.delegate = self
        
        textField.becomeFirstResponder()
    }
    
}

extension STPasswordViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "passwordCell", for: indexPath) as! PasswordCell
        cell.circle.backgroundColor = .systemGroupedBackground
        cell.circle.layer.cornerRadius = 15
        
        return cell
    }
    
}

extension STPasswordViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = trunc(collectionView.frame.width / 6) - 5
        let height: CGFloat = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension STPasswordViewController: UITextFieldDelegate {
    
}

class PasswordCell: UICollectionViewCell {
    @IBOutlet var circle: UIView!
}

enum passwordMode {
    case check
    case set
    case modify
}
