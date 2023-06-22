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

        self.view.backgroundColor = .green
        tableView.dataSource = self
        
        MyPage.getMyPageData(completion: { titles, contents in
            print(titles)
            print(contents)
            self.titles = titles
            self.contents = contents
        })
    }
    
}

extension STMyPageListViewController: UITableViewDataSource {
    
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
    
}
