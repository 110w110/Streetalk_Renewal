//
//  STNoticeDetailViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/12.
//

import UIKit

class STNoticeDetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    var notice: Notice?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = notice?.title
        timeLabel.text = notice?.createdDate
        contentLabel.text = notice?.content
    }

}
