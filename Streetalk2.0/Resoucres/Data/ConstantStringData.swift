//
//  myPage.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/22.
//

struct ConstantStringData {
    // MyPage
    public static let sectionCount = 2
    public static let sectionTitles: [String] = ["이용 안내", "기타 설정"]
    public static let section1: [String] = ["문의하기", "공지사항", "이용약관", "개인정보 처리방침"]
    public static let section2: [String] = ["로그아웃", "잠금 설정", "회원 탈퇴"]
    public static let helpMessage = "\n문의 사항은 아래의 메일로 주시면 검토 후 연락 드리겠습니다.\n(dev.hantae@gmail.com)"
    
    // Board
    public static let myBoardSection = ["내 게시글", "내 댓글", "추천한 게시글", "내 스크랩"]
    public static let helpServiceTargetEmail: String = "dev.hantae@gmail.com"
    public static let boardRequestMailForm: String = """
                         스트릿톡 서비스에 관심을 가지고 도움을 주셔서 감사합니다.
                         요청해주신 사항을 면밀히 검토하겠습니다.
                         
                         아래에 추천하고 싶으신 게시판에 대해 작성해주세요.
                         
                         게시판명 :
                         게시판 목적:
                         
                         """
    
    
    public static func getMyPageData(completion: ([String], [Array<String>])->()) {
        completion(sectionTitles, [section1, section2])
    }
}
