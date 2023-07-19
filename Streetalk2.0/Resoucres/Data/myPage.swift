//
//  myPage.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/22.
//

struct MyPage {
    public static let sectionCount = 2
    
    public static let sectionTitles: [String] = ["이용 안내", "기타 설정"]
    
    public static let section1: [String] = ["문의하기", "공지사항", "이용약관", "개인정보 처리방침"]
    public static let section2: [String] = ["로그아웃", "잠금 설정", "회원 탈퇴"]
    
    public static func getMyPageData(completion: ([String], [Array<String>])->()) {
        completion(sectionTitles, [section1, section2])
    }
}
