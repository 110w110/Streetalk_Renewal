//
//  STSearchListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import UIKit

class STSearchListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    private var postList: [SearchPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func searchTextFieldEditing(_ sender: Any) {
        guard let text = self.searchTextField.text else { return }
        print(text)
        let request = SearchRequest(additionalInfo: text)
        request.request(completion: { result in
            switch result {
            case let .success(data):
                print(data)
                self.postList = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        })
    }
    
}


extension STSearchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! STPostTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = postList[indexPath.row].title
        cell.contentLabel.text = postList[indexPath.row].content
//        cell. = postList[indexPath.row].
        return cell
    }
    
}

extension STSearchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // indexPath에 따라 정보 넘겨야함
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        let postViewController = storyboard.instantiateViewController(withIdentifier: "postViewController") as! STPostViewController
        postViewController.title = "지역 게시판"
        postViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
}
