//
//  STPostViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/26.
//

import UIKit

class STPostViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        collectionView.dataSource = self
//        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}


extension STPostViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postContentTableViewCell", for: indexPath) as! STPostTableViewCell
            cell.selectionStyle = .none
            cell.primaryNickNameStackView.isHidden = true
            cell.secondaryNickNameStackView.isHidden = false
            return cell
//        }
    }
    
}

extension STPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension STPostViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! STPostContentsCollectionViewCell
        cell.setRoundedBorder(shadow: true)
        return cell
    }
    
}

extension STPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! STPostContentsCollectionViewCell
        let width: CGFloat = collectionView.frame.width - 20
        
        let boundingRect = NSString(string: cell.postContentsLabel.text ?? "temp").boundingRect(with: CGSize(width: width - 60, height: CGFloat.greatestFiniteMagnitude),
                                                options: .usesLineFragmentOrigin,
                                                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)],
                                                context: nil)

        return CGSize(width: width, height: boundingRect.height + 160)
    }
}
