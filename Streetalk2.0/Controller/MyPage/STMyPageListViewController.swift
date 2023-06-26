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

extension STMyPageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                showNextViewController(identifier: "myPageFAQViewController", title: self.contents[0][indexPath.row], viewControllerType: STMyPageFAQViewController.self)
            case 1:
                showNextViewController(identifier: "myPageHelpViewController", title: self.contents[0][indexPath.row], viewControllerType: STMyPageHelpViewController.self)
            case 2:
                showNextViewController(identifier: "myPageTermsViewController", title: self.contents[0][indexPath.row], viewControllerType: STMyPageTermsViewController.self)
            case 3:
                showNextViewController(identifier: "myPagePrivacyPolicyViewController", title: self.contents[0][indexPath.row], viewControllerType: STMyPagePrivacyPolicyViewController.self)
            default:
                print("Error: Invalid indexPath row")
            }
        case 1:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "popUpSegue", sender: [self.contents[1][indexPath.row], "로그아웃 하시겠습니까?", PopUpViewUsage.logout] as [Any])
            case 2:
                performSegue(withIdentifier: "popUpSegue", sender: [self.contents[1][indexPath.row], "확인을 누르시면 되돌릴 수 없습니다.", PopUpViewUsage.leave] as [Any])
            default:
                print("Error: Invalid indexPath row")
            }
        default:
            print("Error: Invalid indexPath section")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popUpSegue" {
            guard let sender = sender as? Array<Any> else { return }
            let nextViewController = segue.destination as! STMyPagePopUpViewController
            nextViewController.popUpTitle = sender[0] as! String
            nextViewController.popUpContent = sender[1] as! String
            nextViewController.popUpUsage = sender[2] as! PopUpViewUsage
        }
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
        cell.selectionStyle = .none
        
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

extension STMyPageListViewController {
    
    private func showNextViewController<T: UIViewController>(identifier: String, title: String, viewControllerType: T.Type) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? T else { return }
        viewController.title = title
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showPopUpViewController(identifier: String, title: String, contents: String) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) as? STMyPagePopUpViewController else { return }
        viewController.title = title
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
}