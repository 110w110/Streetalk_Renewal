//
//  STBoardListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STBoardListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

}

extension STBoardListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath) as! STPostTableViewCell
        return cell
    }
    
}


