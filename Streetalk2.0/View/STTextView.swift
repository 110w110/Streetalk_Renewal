//
//  STTextView.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/15.
//

import UIKit

class STTextView: UITextView {

    private var placeholder: String?
    
    public func setPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
        self.text = placeholder
        self.textColor = .placeholderText
    }
    
    public func getPlaceholder() -> String? {
        return placeholder
    }
    
    public func isEmpty() -> Bool {
        return self.text == "" || self.text == placeholder
    }
    
}
