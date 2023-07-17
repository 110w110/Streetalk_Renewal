//
//  String+.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/19.
//

import Foundation

extension String {
    
    func isValidPhoneNum() -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$").evaluate(with: self)
    }
    
    func toNameWithIndustry(industry: String?) -> String {
        guard let industry = industry else { return self + "미선택"}
        return self + " | " + industry
    }
}
