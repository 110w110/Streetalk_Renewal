//
//  PostList.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/06.
//

import Foundation

struct PostList: Codable {
    let postId : Int?
    let title : String?
    let content : String?
    let location : String?
    let writer : String?
    let postLike : Bool?
    let postScrap : Bool?
    let lastTime : Int?
    let likeCount : Int?
    let scrapCount : Int?
    let replyCount : Int?

}
