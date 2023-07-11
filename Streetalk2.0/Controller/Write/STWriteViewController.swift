//
//  STWriteViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STWriteViewController: UIViewController {

    @IBOutlet weak var writeContentTextView: STTextView!
    @IBOutlet weak var writtingBackgroundImageView: UIImageView!
    @IBOutlet var keyboardArea: UIView!
    
    private var mainBoardList: [Board] = []
    private var subBoardList: [Board] = []
    
    private var targetBoardId: Int = 0
    
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
        
        lazy var boardButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "게시판 선택", style: .plain, target: self, action: #selector(boardButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        self.navigationItem.rightBarButtonItem = submitButton
        self.navigationItem.leftBarButtonItem = boardButton
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func writeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
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
