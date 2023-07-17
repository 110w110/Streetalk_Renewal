//
//  STPasswordViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/13.
//

import UIKit

class STPasswordViewController: UIViewController {
    @IBOutlet var textField: UITextField!
    @IBOutlet var primaryLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var mode: passwordMode = .set
    var passHandler: (() -> ())?
    
    private let realNumber: String = Foundation.UserDefaults.standard.string(forKey: "localPassword") ?? ""
    private var inputPassword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(passwordEditing), for: .editingChanged)
        
        initialSetUI()
    }
    
    @objc func passwordEditing(_ sender: Any) {
        switch mode {
        case .set:
            inputInSet()
        case .modify:
            inputInSet()
        case .check:
            inputInCheck()
        }
    }
    
}

extension STPasswordViewController {
    private func initialSetUI() {
        switch mode {
        case .set:
            primaryLabel.text = "비밀번호 설정"
            secondaryLabel.text = "사용하실 비밀번호를 설정해주세요"
        case .modify:
            primaryLabel.text = "비밀번호 설정"
            secondaryLabel.text = "사용하실 비밀번호를 설정해주세요"
        case .check:
            primaryLabel.text = "비밀번호 확인"
            secondaryLabel.text = "비밀번호를 입력해주세요"
        }
    }
    
    private func inputInSet() {
        if textField.text?.count ?? 0 >= 6 {
            if inputPassword == "" {
                guard let input = textField.text else { return }
                inputPassword = input
                primaryLabel.text = "비밀번호 확인"
                secondaryLabel.text = "한번 더 입력해주세요"
            } else {
                guard let input = textField.text else { return }
                if inputPassword == input {
                    UserDefaults.standard.set(inputPassword, forKey: "localPassword")
//                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    inputPassword = ""
                    primaryLabel.text = "일치하지 않는 비밀번호"
                    secondaryLabel.text = "다시 입력해주세요"
                }
                
            }
            textField.text = ""
        }
        collectionView.reloadData()
    }
    
    private func inputInCheck() {
        if textField.text?.count ?? 0 >= 6 {
            guard let input = textField.text else { return }
            if realNumber == input {
                if let completion = passHandler {
                    completion()
                    // 세팅에서는 알럿뷰로 없앨건지 변경할건지 선택시키기
                    // 첫화면에서는 dismiss
                }
            } else {
                primaryLabel.text = "비밀번호 확인"
                secondaryLabel.text = "잘못된 암호입니다"
            }
            textField.text = ""
        }
        collectionView.reloadData()
    }
}

extension STPasswordViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "passwordCell", for: indexPath) as! PasswordCell
        cell.circle.layer.cornerRadius = 15
        if indexPath.row < textField.text?.count ?? 0 {
            cell.circle.backgroundColor = .streetalkPink
        } else {
            cell.circle.backgroundColor = .systemGray5
        }
        
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

class PasswordCell: UICollectionViewCell {
    @IBOutlet var circle: UIView!
}

enum passwordMode {
    case check
    case set
    case modify
}
