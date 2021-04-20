//
//  SSOManger.swift
//  Touch
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import Foundation

internal let TouchLoginEvent = "TouchWidgetLoginEvent"

internal class SSOManager{
    public static var shared = SSOManager()

    weak var loginDelegate: TouchLoginManagerProtocol?
    
    private(set) var userId: String? = nil {
        didSet{
            broadcast(event: TouchLoginEvent, userId: userId)
        }
    }

    func requestLogin(){
        loginDelegate?.requestLogin()
    }
    
    func login(userId: String?){
        self.userId = userId
    }
    
    func logout(){
        userId = nil
    }
    
    private func broadcast(event: String = TouchLoginEvent, userId: String? = nil){
        let userInfo:[String:Any]? = userId != nil ? ["userID": userId!] : nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TouchLoginEvent), object: nil, userInfo: userInfo)
    }
}
