//
//  Int+.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/11.
//

import Foundation

extension Int {
    
    func toLastTimeString() -> String {
        let time = self
        var result : String = ""
        if time > 525600 * 60 {
            result = String(Int(time / 525600 / 60)) + "년 전"
        }
        else if time > 43200 * 60 {
            result = String(Int(time / 43200 / 60)) + "개월 전"
        }
        else if time > 1440 * 60 {
            result = String(Int(time / 1440 / 60)) + "일 전"
        }
        else if time > 60 * 60 {
            result = String(Int(time / 60 / 60)) + "시간 전"
        }
        else if time > 60 {
            result = String(time / 60) + "분 전"
        }
        else {
            result = "방금 전"
        }
        return result
    }
    
    func toString() -> String {
        return "\(self)"
    }
}
