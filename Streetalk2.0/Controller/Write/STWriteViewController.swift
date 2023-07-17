//
//  STWriteViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STWriteViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var writeTitleTextField: UITextField!
    @IBOutlet weak var writeContentTextView: STTextView!
    @IBOutlet weak var writtingBackgroundImageView: UIImageView!
    @IBOutlet var keyboardArea: UIView!
    
    private var uploadImageList: [UIImage] = [UIImage(systemName: "plus.circle.fill")!]
    private var mainBoardList: [Board] = []
    private var subBoardList: [Board] = []
    private let imagePickerController = UIImagePickerController()
    private var targetBoardId: Int = 1
    private var targetBoardName: String = ""
    private var anonymous: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchBoardList()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        writeContentTextView.delegate = self
        writeContentTextView.setPlaceholder(placeholder: "게시글 내용을 작성해주세요.")
        writeContentTextView.keyboardDismissMode = .onDrag
        
        lazy var submitButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(writeButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        lazy var cancelButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
//        lazy var boardButton: UIBarButtonItem = {
//            let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: self, action: #selector(boardButtonTapped(_:)))
//            button.tintColor = .streetalkPink
//            return button
//        }()
        
//        self.navigationItem.leftBarButtonItem = boardButton
        self.navigationItem.rightBarButtonItems = [submitButton, cancelButton]
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func writeButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "작성하신 글은 수정하실 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "작성", style: .default) { (action) in
            if self.writeTitleTextField.text == "" || self.writeContentTextView.text == "" {
                let alert = UIAlertController(title: nil, message: "제목과 본문을 채워주세요", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "닫기", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil)
                return
            }
            
            // TODO: Post 구현 후 익명성 등 여러가지 확인해야함
            let request = PostPostRequest(param: ["boardId" : self.targetBoardId,
                                                  "title" : self.writeTitleTextField.text ?? "",
                                                  "content" : self.writeContentTextView.text ?? "",
                                                  "checkName" : self.anonymous,
                                                  "isPrivate" : self.anonymous])
            // TODO: request의 파라미터로 이미지 리스트 넘겨야함
            request.request(multipart: true, completion: { result in
                switch result {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            })
            self.dismiss(animated: true)
        }
        let cancleAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancleAction)
        present(alert, animated: false, completion: nil)
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "작성 중인 내용은 모두 사라집니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "나가기", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancleAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancleAction)
        present(alert, animated: false, completion: nil)
    }
    
    func boardButtonTapped() {
        let alert = UIAlertController(title: "게시판 선택", message: nil, preferredStyle: .alert)
        for board in self.mainBoardList {
            let action = UIAlertAction(title: board.boardName, style: .default) {_ in
                self.targetBoardId = board.id ?? 0
                self.targetBoardName = board.boardName ?? ""
                self.title = self.targetBoardName
                self.tableView.reloadData()
            }
            alert.addAction(action)
        }
        for board in self.subBoardList {
            let action = UIAlertAction(title: board.boardName, style: .default) {_ in
                self.targetBoardId = board.id ?? 0
                self.targetBoardName = board.boardName ?? ""
                self.title = self.targetBoardName
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func fetchBoardList() {
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
                        self.targetBoardId = self.mainBoardList[0].id ?? 1
                        self.targetBoardName = self.mainBoardList[0].boardName ?? ""
                        self.title = self.targetBoardName
                        self.tableView.reloadData()
                    }
                }
            case let .failure(error):
                print(error)
            }
        })
    }
    
}

extension STWriteViewController {
    @objc func switchValueChanged(_ sender: UISwitch) {
        // 테이블 뷰 자체가 가진 속성을 설정합니다.
        anonymous = sender.isOn
        print(anonymous)
    }
}

extension STWriteViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let contentTextView = textView as! STTextView
        if contentTextView.text == "" {
            contentTextView.text = contentTextView.placeholder
            contentTextView.textColor = .placeholderText
            self.writtingBackgroundImageView.isHidden = false
        } else {
            self.writtingBackgroundImageView.isHidden = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.writtingBackgroundImageView.isHidden = true
        let contentTextView = textView as! STTextView
        if contentTextView.text == contentTextView.placeholder {
            contentTextView.text = ""
            contentTextView.textColor = .label
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        self.keyboardArea.isHidden = false
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        self.keyboardArea.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension STWriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            boardButtonTapped()
        }
    }
}

extension STWriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "writeTableViewCell") as! STWriteTableViewCell
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.label.text = "게시판 변경"
            cell.toggle.isHidden = true
            cell.detailLabel.text = targetBoardName
        } else {
            cell.label.text = "익명"
            cell.detailLabel.isHidden = true
            cell.toggle.isOn = false
            cell.toggle.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        }
        return cell
    }
    
    
}

extension STWriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "writeCollectionViewCell", for: indexPath) as! STWriteCollectionViewCell
        cell.imageView.image = uploadImageList[indexPath.row]
        return cell
    }
    
    
}

extension STWriteViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.height - 10
        let height: CGFloat = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class STWriteTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var toggle: UISwitch!
}

class STWriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}
