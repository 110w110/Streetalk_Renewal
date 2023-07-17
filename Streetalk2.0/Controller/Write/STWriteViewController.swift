//
//  STWriteViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STWriteViewController: UIViewController {

    @IBOutlet var writeTitleTextField: UITextField!
    @IBOutlet weak var writeContentTextView: STTextView!
    @IBOutlet weak var writtingBackgroundImageView: UIImageView!
    @IBOutlet var keyboardArea: UIView!
    
    private var mainBoardList: [Board] = []
    private var subBoardList: [Board] = []
    
    private var targetBoardId: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchBoardList()
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
        
        lazy var boardButton: UIBarButtonItem = {
            let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: self, action: #selector(boardButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        lazy var imageButton: UIBarButtonItem = {
            let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle.portrait"), style: .plain, target: self, action: #selector(boardButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        self.navigationItem.leftBarButtonItem = boardButton
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
                                                "checkName" : false,
                                                "isPrivate" : false])
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
    
    @objc func boardButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "게시판 선택", message: nil, preferredStyle: .alert)
        for board in self.mainBoardList {
            let action = UIAlertAction(title: board.boardName, style: .default) {_ in
                self.targetBoardId = board.id ?? 0
                self.title = board.boardName ?? "게시판"
            }
            alert.addAction(action)
        }
        for board in self.subBoardList {
            let action = UIAlertAction(title: board.boardName, style: .default) {_ in
                self.targetBoardId = board.id ?? 0
                self.title = board.boardName ?? "게시판"
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
                        self.title = self.mainBoardList[0].boardName ?? "게시판"
                    }
                }
            case let .failure(error):
                print(error)
            }
        })
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
