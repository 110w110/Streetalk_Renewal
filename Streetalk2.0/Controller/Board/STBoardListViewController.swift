//
//  STBoardListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/07.
//

import UIKit
import MessageUI

class STBoardListViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var myBoardListCollectionView: UICollectionView!
    @IBOutlet var mainBoardListCollectionView: UICollectionView!
    @IBOutlet var subBoardListCollectionView: UICollectionView!
    
    @IBOutlet var mainBoardEmptyLabel: UILabel!
    @IBOutlet var subBoardEmptyLabel: UILabel!
    
    @IBOutlet var mainBoardHeight: NSLayoutConstraint!
    @IBOutlet var subBoardHeight: NSLayoutConstraint!
    
    private let refreshControl = UIRefreshControl()
    
    private let myBoardImageList = [UIImage(named: "MyPost"), UIImage(named: "MyComment"), UIImage(named: "MyLike"), UIImage(named: "MyScrap")]
    private let myBoardTitles = ["내 게시글", "내 댓글", "추천한 게시글", "내 스크랩"]
    private let myBoardMode: [ListMode] = [.myPost, .myReply, .myLike, .myScrap]
    
    private var mainBoardList: [Board] = []
    private var subBoardList: [Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myBoardListCollectionView.dataSource = self
        myBoardListCollectionView.delegate = self
        mainBoardListCollectionView.dataSource = self
        mainBoardListCollectionView.delegate = self
        subBoardListCollectionView.dataSource = self
        subBoardListCollectionView.delegate = self
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        getBoardList()
        setUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        mainBoardHeight.constant = mainBoardListCollectionView.collectionViewLayout.collectionViewContentSize.height
        subBoardHeight.constant = subBoardListCollectionView.collectionViewLayout.collectionViewContentSize.height
        view.layoutIfNeeded()
    }
    
    @IBAction func boardSuggestionButtonTapped(_ sender: Any) {
        mailBoardSuggestion()
    }
    
    @objc private func refreshUI() {
        print("refresh")
        getBoardList()
    }
    
    func setUI() {
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        myBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
        mainBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
        subBoardListCollectionView.setRoundedBorder(shadow: true, bottomExtend: false)
        
        if mainBoardList.count == 0 {
            mainBoardEmptyLabel.isHidden = false
        } else {
            mainBoardEmptyLabel.isHidden = true
        }
        
        if subBoardList.count == 0 {
            subBoardEmptyLabel.isHidden = false
        } else {
            subBoardEmptyLabel.isHidden = true
        }
    }

    func getBoardList() {
        let request = BoardListRequest()
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                for board in data {
                    if board.category == "main" {
                        if !self.mainBoardList.contains(where: { $0.boardName == board.boardName }) {
                            self.mainBoardList.append(board)
                        }
                    } else if board.category == "sub" {
                        if !self.subBoardList.contains(where: { $0.boardName == board.boardName }) {
                            self.subBoardList.append(board)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.mainBoardListCollectionView.reloadData()
                    self.subBoardListCollectionView.reloadData()
                    self.mainBoardListCollectionView.translatesAutoresizingMaskIntoConstraints = false
                    self.mainBoardListCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(self.mainBoardList.count * 50)).isActive = true
                    self.subBoardListCollectionView.translatesAutoresizingMaskIntoConstraints = false
                    self.subBoardListCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(self.subBoardList.count * 50)).isActive = true
                    self.setUI()
                    self.refreshControl.endRefreshing()
                }
            case let .failure(error):
                print(error)
                self.errorMessage(error: error, message: #function)
            }
        })
    }
}

extension STBoardListViewController: MFMailComposeViewControllerDelegate {
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "전송 불가", message: "이메일 앱 연결을 확인해주세요", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailBoardSuggestion() {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([ConstantStringData.helpServiceTargetEmail])
            viewController.setSubject("Streetalk Board Suggestion")
            let body = ConstantStringData.boardRequestMailForm
            viewController.setMessageBody(body, isHTML: false)
            self.present(viewController, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
}

extension STBoardListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myBoardListCollectionView {
            return min(4, myBoardTitles.count)
        } else if collectionView == mainBoardListCollectionView {
            return mainBoardList.count
        } else if collectionView == subBoardListCollectionView {
            return subBoardList.count
        }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == myBoardListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myBoardListCell", for: indexPath)
            
            for view in cell.subviews {
                view.removeFromSuperview()
            }
            
            let imageView = {
                let view = UIImageView(image: myBoardImageList[indexPath.row]?.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)))
                view.contentMode = .scaleAspectFit
                return view
            }()
            
            let label = {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                label.text = myBoardTitles[indexPath.row]
                label.textAlignment = .center
                return label
            }()
            
            cell.addSubview(imageView)
            cell.addSubview(label)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0).isActive = true
            imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true
            imageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: 0).isActive = true
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0).isActive = true
            label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0).isActive = true
            label.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
            label.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            return cell
        }
        
        let cell = {
            if collectionView == mainBoardListCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boardCollectionViewCell", for: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subBoardCollectionViewCell", for: indexPath)
                return cell
            }
        }()
        
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        let label = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            if collectionView == mainBoardListCollectionView {
                label.text = mainBoardList[indexPath.row].boardName
            } else if collectionView == subBoardListCollectionView {
                label.text = subBoardList[indexPath.row].boardName
            }
            
            return label
        }()
        
        cell.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        
        return cell
    }
    
}

extension STBoardListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainBoardListCollectionView || collectionView == subBoardListCollectionView {
            let width: CGFloat = collectionView.frame.width
            let height: CGFloat = 50
            return CGSize(width: width, height: height )
        } else if collectionView == myBoardListCollectionView {
            let width: CGFloat = collectionView.frame.width / 4
            let height: CGFloat = collectionView.frame.height - 20
            return CGSize(width: width, height: height )
        }
        return CGSize(width: 0.0, height: 0.0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension STBoardListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "postListViewController") as! STPostListViewController

        if collectionView == myBoardListCollectionView {
            viewController.title = myBoardTitles[indexPath.row]
            viewController.listMode = myBoardMode[indexPath.row]
        } else if collectionView == mainBoardListCollectionView {
            viewController.boardId = mainBoardList[indexPath.row].id
            viewController.boardName = mainBoardList[indexPath.row].boardName
            viewController.title = mainBoardList[indexPath.row].boardName
        } else if collectionView == subBoardListCollectionView {
            viewController.boardId = subBoardList[indexPath.row].id
            viewController.boardName = subBoardList[indexPath.row].boardName
            viewController.title = subBoardList[indexPath.row].boardName
            viewController.isSubBoard = true
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
