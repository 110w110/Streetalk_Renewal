//
//  Responsable.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/11.
//

import Foundation

protocol Responsable: Codable {
//    func dataToObject(_ data: Data) -> Codable
    var result: Codable? { get }
}
