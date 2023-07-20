//
//  UIViewController+.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/11.
//

import UIKit

// Device Info
extension UIViewController {
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }

    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    func errorMessage(error: APIError, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message ?? "unknown error", message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    static func errorMessage(error: APIError, message: String?, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: message ?? "unknown error", message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okay)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
