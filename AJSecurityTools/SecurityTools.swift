//
//  SecurityTools.swift
//  AJSecurityTools
//
//  Created by 安静的为你歌唱 on 2020/1/11.
//  Copyright © 2020 安静的为你歌唱. All rights reserved.
//

import UIKit
import LocalAuthentication

class SecurityTools: NSObject {
    private lazy var context: LAContext = {
        let context = LAContext.init()
        return context
    }()
    
    typealias backSuccess = (_ success : Bool) -> Void
    typealias failureBack = (_ error : Error) -> Void
    typealias deviceState = (_ error : NSError) -> Void
    
    static let shareInstance = SecurityTools()
}

//MARK:-- 公共方法
extension SecurityTools {
    /// 是否支持FaceID
    func isSupportFaceID() -> Bool {
        if #available(iOS 11, *) {
            if isSupprotSecurity().domain.isEmpty {
                switch context.biometryType {
                case .faceID:
                    return true
                case .none:
                    return false
                default:
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func deviceBiometricsState() -> NSErrorPointer {
        let error: NSErrorPointer = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: error) {
            return error
        } else {
            return error
        }
    }
    
    func evaluatePolicy(localizedReason : String, fallbackTitle title : String, SuccesResult backSucces : @escaping backSuccess, FailureResult backFailure : @escaping failureBack, DeviceState deviceState: @escaping deviceState) -> Void {
        let error =  self.isSupprotSecurity()
        if error.domain.isEmpty{
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        backSucces(success)
                    }
                } else {
                    DispatchQueue.main.async {
                        backFailure(error!)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                deviceState(error)
            }
        }
    }
    
    func isBiometricsOpened() -> Bool {
        let isOpenStr = UserDefaults.standard.object(forKey: "BiometricsOpened") as? String
        if isOpenStr == "1" {
            return true
        } else {
            return false
        }
    }
    
    func biometricsLibraryDidChanged() -> Void {
        
    }
    
}

//MARK:-- 私有方法
extension SecurityTools {
    private func isSupprotSecurity() -> NSError {
        var error : NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return error ?? NSError.init()
        } else {
            return error!
        }
    }
    
    private func getTouchIDData() -> Data? {
        let data = UserDefaults.standard.object(forKey: "TouchIdData")
        return data as? Data
    }
    
    func saveBiometricsLibraryInfo() -> Void {
        
    }
}

