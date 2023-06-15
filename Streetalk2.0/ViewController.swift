//
//  ViewController.swift
//  Streetalk2.0
//
//  Created by 한태희 [hantae] on 2023/03/31.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

/*
 앱에 대한 설명
 
 - UI 구현 방식에 대한 설명
 일단 storyboard로만 구현했던 기존의 방식에서 조금 벗어나서 화면 구성만 담당하도록 변경
 모든 UI를 코드로 구현하기에는 전체적으로 UI 구현이 굉장히 많아서 빠르게 리팩토링하기 어렵다고 판단
 
 - 디자인 패턴에 대한 설명
 MVC를 기준으로 구현하되, iOS 구현 상에서 View와 Controller 간의 의존성 문제는 억지로 분리하지 않음
 
 - 네트워크 통신에 대한 설명
 기존 구현에서는 모두 Alamofire를 통한 통신을 선택했지만 조금 더 네트워크 통신에 대한 이해도를 높이기 위해 URLSession을 통해 직접 통신하도록 구현
 
 
 
 */
