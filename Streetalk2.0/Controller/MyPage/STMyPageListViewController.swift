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
    private var homeInfo: HomeInfo?
    
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
        
        fetchHomeData()
    }
    
    @IBAction func profileSettingButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Join", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "joinRegisterViewController") as! STJoinRegisterViewController
        nextViewController.title = "프로필 관리"
        let navigationController = UINavigationController(rootViewController: nextViewController)
        self.present(navigationController, animated: true)
    }
    
}

extension STMyPageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                showNextViewController(identifier: "myPageFAQViewController", title: self.contents[0][indexPath.row], viewControllerType: STMyPageFAQViewController.self)
            case 1:
                showNextViewController(identifier: "myPageNoticeViewController", title: self.contents[0][indexPath.row], viewControllerType: STMyPageNoticeViewController.self)
            case 2:
                showNextViewController(identifier: "myPageTermsViewController", title: self.contents[0][indexPath.row], viewControllerType: STMyPageTermsViewController.self)
            case 3:
                showNextViewController(identifier: "myPagePrivacyPolicyViewController", title: self.contents[0][indexPath.row], viewControllerType: STMyPagePrivacyPolicyViewController.self)
            default:
                print("Error: Invalid indexPath row")
            }
        case 2:
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "popUpSegue", sender: [self.contents[1][indexPath.row], "로그아웃 하시겠습니까?", PopUpViewUsage.logout] as [Any])
            case 1:
                if let password = UserDefaults.standard.string(forKey: "localPassword"), password != "" {
                    let handler = {
                        // alert view 띄워서 확인 후
                        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                        let modify = UIAlertAction(title: "비밀번호 변경", style: .default) { _ in
                            self.showPasswordViewController(mode: .set, identifier: "passwordViewController", title: "암호 설정", storyboard: UIStoryboard(name: "Password", bundle: nil))
                        }
                        let remove = UIAlertAction(title: "비밀번호 비활성화", style: .default) { _ in
                            UserDefaults.standard.set("", forKey: "localPassword")
                            self.navigationController?.popViewController(animated: true)
                        }
                        let usingBio = UserDefaults.standard.bool(forKey: "usingBioAuth")
                        let bioauth = UIAlertAction(title: usingBio ? "생체인증 비활성화" : "생체인증 활성화", style: .default) { _ in
                            UserDefaults.standard.set(!usingBio, forKey: "usingBioAuth")
                            self.navigationController?.popViewController(animated: true)
                        }
                        let cancel = UIAlertAction(title: "취소", style: .cancel)
                        alert.addAction(modify)
                        alert.addAction(remove)
                        alert.addAction(bioauth)
                        alert.addAction(cancel)
                        self.present(alert, animated: true)
                    }
                    showPasswordViewController(mode: .check, passHandler: handler, identifier: "passwordViewController", title: "암호 확인", storyboard: UIStoryboard(name: "Password", bundle: nil))
                } else {
                    showPasswordViewController(mode: .set, identifier: "passwordViewController", title: "암호 설정", storyboard: UIStoryboard(name: "Password", bundle: nil))
                }
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
            nextViewController.targetViewController = self
        }
    }
    
}

extension STMyPageListViewController: UITableViewDataSource {
    
    // cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.contents[section - 1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! STProfileCell
            cell.selectionStyle = .none
            cell.location.text = homeInfo?.location
            cell.industry.text = homeInfo?.industry
            cell.nickName.text = "\(homeInfo?.userName ?? "거리지기") 사장님"
            return cell
            
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myPageCell", for: indexPath) as? STMyPageTableViewCell else { return UITableViewCell() }
        let contents = self.contents[indexPath.section - 1]
        cell.contentLabel.text = contents[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    // section
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titles.count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return self.titles[section - 1]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240
        }
        return 50
    }
    
}

extension STMyPageListViewController {
    
    private func fetchHomeData() {
        let request = HomeInfoRequest()
        request.request(completion: { result in
            switch result {
            case let .success(object):
                self.homeInfo = object
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        })
    }
    
    private func showNextViewController<T: UIViewController>(identifier: String, title: String, viewControllerType: T.Type, storyboard: UIStoryboard = UIStoryboard(name: "MyPage", bundle: nil)) {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else { return }
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
    
    private func showPasswordViewController(mode: passwordMode, passHandler: @escaping (() -> ()) = {}, identifier: String, title: String, storyboard: UIStoryboard = UIStoryboard(name: "MyPage", bundle: nil)) {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? STPasswordViewController else { return }
        viewController.title = title
        viewController.mode = mode
        viewController.passHandler = passHandler
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

class STProfileCell: UITableViewCell {
    @IBOutlet var location: UILabel!
    @IBOutlet var industry: UILabel!
    @IBOutlet var nickName: UILabel!
}
