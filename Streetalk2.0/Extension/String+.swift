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
    
//    func toSimpleDateFormat() -> String {
//        let date = self[self.index(after: self.startIndex) ..< self.index(self.startIndex, offsetBy: 3)]
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let convertDate = dateFormatter.date(from: self)
//        return ""
//    }
}
