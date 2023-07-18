//
//  STRegisterJobCollectionViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/20.
//

import UIKit

class STRegisterJobCollectionViewCell: UICollectionViewCell {
    @IBOutlet var jobLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .streetalkPink.withAlphaComponent(0.3)
            } else {
                self.backgroundColor = .clear
            }
        }
    }
    
}
