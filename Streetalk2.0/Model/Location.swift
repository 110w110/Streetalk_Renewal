//
//  Location.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/05.
//

import Foundation

struct Location: Codable {
    let longitude: Double?   // 경도
    let latitude: Double?    // 위도
    
    init(longitude: Double?, latitude: Double?) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
}
