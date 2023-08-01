//
//  STWriteViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit
import Kingfisher

class STWriteViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var writeTitleTextField: UITextField!
    @IBOutlet weak var writeContentTextView: STTextView!
    @IBOutlet weak var writtingBackgroundImageView: UIImageView!
    @IBOutlet var keyboardArea: UIView!
    
    private let placeholder = "게시글 내용을 작성해주세요.\n\n부적절하거나 타인에게 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있으며, 해당 사유에 따라 활동 정지 또는 추방 조치될 수 있습니다.\n\n타인을 명예를 훼손하는 비방을 하거나 저작권을 위반하는 등 악의적인 게시글을 작성하는 사용자는 법적 조치의 대상이 될 수 있습니다."
    private let imagePickerController = UIImagePickerController()
    
    private var uploadImageList: [UIImage] = [UIImage(named: "Add")!]
    private var mainBoardList: [Board] = []
    private var subBoardList: [Board] = []
    private var targetBoardName: String = ""
    private var anonymous: Bool = false
    
    var targetBoardId: Int = 1
    var mode: HttpMethods = .post
    var targetModifyPostId: Int?
    var currentPost: Post?
    var currentPostId: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchBoardList()
        
        imagePickerController.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        pickerView.delegate = self
        
        writeContentTextView.delegate = self
        writeContentTextView.setPlaceholder(placeholder)
        writeContentTextView.keyboardDismissMode = .onDrag
        
        self.hideKeyboardWhenTappedAround()
        
        lazy var submitButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "등록", style: .done, target: self, action: #selector(writeButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        lazy var cancelButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelButtonTapped(_:)))
            button.tintColor = .streetalkPink
            return button
        }()
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = submitButton
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        setCurrentPostData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func writeButtonTapped(_ sender: UIButton) {
        if mode == .post {
            let alert = UIAlertController(title: nil, message: "부적절한 게시글을 작성하게 되면 확인하는 즉시 조치되며, 활동 정지 처리됩니다. 또한 게시글 작성 후에는 수정하실 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "작성", style: .default) { _ in
                guard let titleText = self.writeTitleTextField.text, !titleText.isRealEmptyText(),
                      let contentText = self.writeContentTextView.text, !contentText.isRealEmptyText(placeholder: self.placeholder) else {
                    let alert = UIAlertController(title: nil, message: "제목과 본문을 채워주세요", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "닫기", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)
                    return
                }
                
                if titleText.count >= 100 {
                    let alert = UIAlertController(title: nil, message: "제목은 100자 이내로 작성해주세요", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "닫기", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)
                    return
                }
                
                let request = PostPostRequest(param: ["boardId" : self.targetBoardId,
                                                      "title" : self.writeTitleTextField.text ?? "",
                                                      "content" : self.writeContentTextView.text ?? "",
                                                      "checkName" : self.anonymous,
                                                      "isPrivate" : self.anonymous])
                request.request(multipart: true, imageList: Array(self.uploadImageList[0..<self.uploadImageList.count - 1]), completion: { result in
                    switch result {
                    case .success(let data):
                        print(data)
                    case .failure(let error):
                        print(error)
                        self.errorMessage(error: error, message: #function)
                    }
                })
                self.dismiss(animated: true)
            }
            let cancleAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancleAction)
            present(alert, animated: false, completion: nil)
        } else if mode == .put {
            let alert = UIAlertController(title: nil, message: "게시글을 등록하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "작성", style: .default) { _ in
                guard let titleText = self.writeTitleTextField.text, !titleText.isRealEmptyText(),
                      let contentText = self.writeContentTextView.text, !contentText.isRealEmptyText(placeholder: self.placeholder) else {
                    let alert = UIAlertController(title: nil, message: "제목과 본문을 채워주세요", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "닫기", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)
                    return
                }
                
                let request = PostPostRequest(methods: .put,
                                                param: ["postId" : self.currentPostId ?? -1,
                                                        "title" : self.writeTitleTextField.text ?? "",
                                                        "content" : self.writeContentTextView.text ?? ""])
                request.request(multipart: true, imageList: Array(self.uploadImageList[0..<self.uploadImageList.count - 1]), completion: { result in
                    switch result {
                    case let .success(data):
                        print(data)
                    case let .failure(error):
                        print(error)
                        self.errorMessage(error: error, message: #function)
                    }
                })
                self.dismiss(animated: true)
            }
            let cancleAction = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(okAction)
            alert.addAction(cancleAction)
            present(alert, animated: false, completion: nil)
            
            
        }
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
        writeTitleTextField.endEditing(true)
        UIView.animate(withDuration: 0.1, animations: {
            self.pickerView.isHidden = !self.pickerView.isHidden
        })
    }
    
    private func fetchBoardList() {
        let request = BoardListRequest()
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                for board in data {
                    if board.category == "main" && board.boardName == "통합게시판" {
                        self.mainBoardList.append(board)
                    } else if board.category == "sub" {
                        self.subBoardList.append(board)
                    }
                    
                    if board.id == self.targetBoardId {
                        self.targetBoardName = board.boardName ?? ""
                    }
                }
                DispatchQueue.main.async {
                    self.title = self.targetBoardName
                    self.tableView.reloadData()
                    self.pickerView.reloadAllComponents()
                }
            case let .failure(error):
                print(error)
                self.errorMessage(error: error, message: #function)
            }
        })
    }
    
}

extension STWriteViewController {
    private func setCurrentPostData() {
        guard let post = currentPost else { return }
        writeTitleTextField.text = post.title
        writeContentTextView.text = post.content
        writeTitleTextField.text = post.title
        writeTitleTextField.text = post.title
        writeContentTextView.textColor = .label
        
        guard let images = currentPost?.images else { return }
        for imageUrl in images {
            var imageView = UIImageView()
            guard let url = URL(string: imageUrl) else { return }
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
              with: url,
              placeholder: nil,
              options: [.transition(.fade(1.2))],
              completionHandler: nil
            )
            uploadImageList.insert(fixOrientation(img: imageView.image ?? UIImage()), at: uploadImageList.count - 1)
        }
        
        self.collectionView.reloadData()
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        anonymous = sender.isOn
    }
}

extension STWriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainBoardList.count + subBoardList.count
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row < mainBoardList.count {
            return mainBoardList[row].boardName
        } else {
            return subBoardList[row - mainBoardList.count].boardName
        }
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < mainBoardList.count {
            self.targetBoardId = mainBoardList[row].id ?? 0
            self.targetBoardName = mainBoardList[row].boardName ?? ""
            self.title = self.targetBoardName
            self.tableView.reloadData()
        } else {
            self.targetBoardId = subBoardList[row - mainBoardList.count].id ?? 0
            self.targetBoardName = subBoardList[row - mainBoardList.count].boardName ?? ""
            self.title = self.targetBoardName
            self.tableView.reloadData()
        }
    }
}

extension STWriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        guard let image = newImage else { return }
        uploadImageList.insert(fixOrientation(img: image), at: uploadImageList.count - 1)
        dismiss(animated: true, completion: {
            self.collectionView.reloadData()
        })
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }

        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)

        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
    }
}

extension STWriteViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let contentTextView = textView as! STTextView
        if contentTextView.text == "" {
            contentTextView.text = contentTextView.getPlaceholder()
            contentTextView.textColor = .placeholderText
            self.writtingBackgroundImageView.isHidden = false
        } else {
            self.writtingBackgroundImageView.isHidden = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.pickerView.isHidden = true
        self.writtingBackgroundImageView.isHidden = true
        let contentTextView = textView as! STTextView
        if contentTextView.text == contentTextView.getPlaceholder() {
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
        if indexPath.row == 1 {
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
            cell.label.text = "익명"
            cell.detailLabel.isHidden = true
            cell.toggle.isOn = false
            cell.toggle.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        } else {
            cell.label.text = "게시판 변경"
            cell.toggle.isHidden = true
            cell.detailLabel.text = targetBoardName
        }
        return cell
    }
    
    
}

extension STWriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == uploadImageList.count - 1 {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "카메라", style: .default) { _ in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            let album = UIAlertAction(title: "앨범 (원본)", style: .default) { _ in
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            let albumEditing = UIAlertAction(title: "앨범 (편집)", style: .default) { _ in
                self.imagePickerController.sourceType = .photoLibrary
                self.imagePickerController.allowsEditing = true
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(camera)
            alert.addAction(album)
            alert.addAction(albumEditing)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        } else {
            uploadImageList.remove(at: indexPath.row)
        }
        collectionView.reloadData()
    }
}

extension STWriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(uploadImageList.count, 10)
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
