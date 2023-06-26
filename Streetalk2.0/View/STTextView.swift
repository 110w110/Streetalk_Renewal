//
//  STTextView.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STTextView: UITextView {

    public var placeholder: String?
    
    public func setPlaceholder(placeholder: String) {
        self.placeholder = placeholder
        self.text = placeholder
        self.textColor = .placeholderText
    }
}
