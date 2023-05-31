//
//  STBannerView.swift
//  Streetalk2.0
//
//  Created by 한태희 [hantae] on 2023/03/31.
//

import UIKit

class STBannerView: UIView {
    
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
