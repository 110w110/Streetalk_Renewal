//
//  STRegisterLocationCollectionViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import UIKit

class STRegisterLocationCollectionViewCell: UICollectionViewCell {
    @IBOutlet var locationLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .streetalkPink.withAlphaComponent(0.1)
            } else {
                self.backgroundColor = .clear
            }
        }
    }
    
}
