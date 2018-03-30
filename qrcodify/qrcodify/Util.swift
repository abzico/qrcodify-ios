//
//  Util.swift
//  qrcodify
//
//  Created by Wasin Thonkaew on 3/30/18.
//  Copyright © 2018 Wasin Thonkaew. All rights reserved.
//

import Foundation
import MBProgressHUD

final class Util {
    private init() {}
    
    static func showHud(view: UIView, text: String="Loading") {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = text
        }
    }
    
    static func hideHud(view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}
