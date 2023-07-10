//
//  HomeInfo.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/10.
//

import Foundation

struct HomeInfo: Codable {
    let userName : String?
    let location : String?
    let industry : String?
    let mainNoticeImgUrl : [String]?
    let notice : String?
    let myLocalPosts : [HomePost]?
    let myIndustryPosts : [HomePost]?
    let newPosts : [HomePost]?
    var likeBoardList : [BoardLiked]?

    enum CodingKeys: String, CodingKey {
        case userName
        case location
        case industry
        case mainNoticeImgUrl
        case notice
        case myLocalPosts
        case myIndustryPosts
        case newPosts
        case likeBoardList
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        industry = try values.decodeIfPresent(String.self, forKey: .industry)
        mainNoticeImgUrl = try values.decodeIfPresent([String].self, forKey: .mainNoticeImgUrl)
        notice = try values.decodeIfPresent(String.self, forKey: .notice)
        myLocalPosts = try values.decodeIfPresent([HomePost].self, forKey: .myLocalPosts)
        myIndustryPosts = try values.decodeIfPresent([HomePost].self, forKey: .myIndustryPosts)
        newPosts = try values.decodeIfPresent([HomePost].self, forKey: .newPosts)
        likeBoardList = try values.decodeIfPresent([BoardLiked].self, forKey: .likeBoardList)
    }

}

struct BoardLiked : Codable {
    let boardName : String?
    let boardId : Int?
}

struct HomePost : Codable {
    let postId : Int?
    let title : String?
    let location : String?
    let time : String?
    let replyCount : Int?
}
