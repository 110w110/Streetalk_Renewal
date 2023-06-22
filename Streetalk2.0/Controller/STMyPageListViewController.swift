//
//  STMyPageListViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STMyPageListViewController: UIViewController {

    private var titles: [String] = []
    private var contents: [Array<String>] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        
        MyPage.getMyPageData(completion: { titles, contents in
            self.titles = titles
            self.contents = contents
        })
    }
    
}

extension STMyPageListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myPageCell", for: indexPath) as? STMyPageTableViewCell else { return UITableViewCell() }
        let contents = self.contents[indexPath.section]
        cell.contentLabel.text = contents[indexPath.row]
        
        return cell
    }
    
    // section
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}
