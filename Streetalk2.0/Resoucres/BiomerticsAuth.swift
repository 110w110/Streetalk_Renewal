//
//  BiomerticsAuth.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/19.
//
// 참고 : https://ios-development.tistory.com/745

import Foundation
import LocalAuthentication

public protocol AuthenticateStateDelegate: AnyObject {
    /// loggedIn상태인지 loggedOut 상태인지 표출
    func didUpdateState(_ state: BiometricsAuth.AuthenticationState)
}

public class BiometricsAuth {

    public enum AuthenticationState {
        case loggedIn
        case LoggedOut
    }

    public weak var delegate: AuthenticateStateDelegate?
    private var context = LAContext()

    init() {
        configure()
    }

    private func configure() {
        /// 생체 인증이 실패한 경우, Username/Password를 입력하여 인증할 수 있는 버튼에 표출되는 문구
        context.localizedCancelTitle = "비밀번호 입력하기"
    }

    public func execute() {

        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "스트릿톡을 잠금해제합니다"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] isSuccess, error in
                // 내부적으로 Face ID가 실패한 경우 자동으로 암호 입력
                // 성공하면 아래 DispatchQueue 실행
                if isSuccess {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.didUpdateState(.loggedIn)
                    }
                } else {
                    print("Failed to authenticate")
                }
            }
        } else {
            print("Can't evaluate policy")
        }
    }
}
