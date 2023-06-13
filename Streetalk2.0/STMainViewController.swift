//
//  STMainViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 [hantae] on 2023/03/31.
//

import UIKit

class STMainViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
//        let registerViewController = STRegisterViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        let banner : bannerView = bannerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), title: "title", content: "content")
        self.view.addSubview(banner)
        self.setBannerLayOut(banner)
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?&key=99672dad40a8f499176d319a49070269&targetDt=20210201"
//        APIClient.shared.request(url: url) { result in
//            switch result {
//            case let .success(data):
//                print(data)
//            case let .failure(error):
//                print(error)
//            }
//        }
//
        
//        let replyRequest = UserInfoRequest(uri: "", methods: .get)
//        replyRequest.request { result in
//            switch result {
//            case let .success(data):
//                print(data)
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
    
    private func setBannerLayOut(_ banner: bannerView) {
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.backgroundColor = .orange
        
        if #available(iOS 11, *) {
            let guide = self.view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                banner.topAnchor.constraint(equalTo: guide.topAnchor, constant: -(self.view.frame.height) * 0.5),
                banner.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
                banner.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.7),
                banner.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
                ])
        } else {
            NSLayoutConstraint.activate([
                banner.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0),
                banner.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                banner.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
                banner.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                ])
        }
        
    }
}

fileprivate class bannerView: UIView {
    
    init(frame: CGRect, title: String?, content: String?){
        super.init(frame: frame)
        
        let placeHolderTitleLabel : UILabel = {
            let label = UILabel()
            label.text = title ?? ""
            return label
        }()
        
        let placeHolderContentLabel : UILabel = {
            let label = UILabel()
            label.text = content ?? ""
            return label
        }()
        
        self.addSubview(placeHolderTitleLabel)
        self.addSubview(placeHolderContentLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
