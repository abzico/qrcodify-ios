//
//  SharedConstants.swift
//  qrcodify
//
//  Created by Wasin Thonkaew on 3/28/18.
//  Copyright © 2018 Wasin Thonkaew. All rights reserved.
//

import Foundation

class SharedConstants {
    public static let APP_GROUP_IDENTIFIER: String = "group.co.abzi.qrcodify"
    public static let INPUTTEXT_KEY: String = "sharedValue"
    public static let DIDREAD_INPUTSTRING_NOTIFICATION_PARAM_STRING: String = "inputString"
    
    enum Notification: String {
        case didReadInputString="didReadInputStringNotification"    // when the app detects there is a next-to-process input string available in UserDefaults, param is input string
    }
}
