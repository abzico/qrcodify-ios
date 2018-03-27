//
//  ShareViewController.swift
//  shareext
//
//  Created by Wasin Thonkaew on 3/28/18.
//  Copyright © 2018 Wasin Thonkaew. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    private var urlString: String?
    private var textString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        let contentTypeURL = kUTTypeURL as String
        let contentTypeText = kUTTypeText as String
        
        for attachment in extensionItem.attachments as! [NSItemProvider] {
            // if it's URL
            if attachment.hasItemConformingToTypeIdentifier(contentTypeURL) {
                attachment.loadItem(forTypeIdentifier: contentTypeURL, options: nil) { (results, error) in
                    let url = results as! URL
                    self.urlString = url.absoluteString
                }
            }
            
            // if it's text
            if attachment.hasItemConformingToTypeIdentifier(contentTypeText) {
                attachment.loadItem(forTypeIdentifier: contentTypeText, options: nil) { (results, error) in
                    let text = results as! String
                    self.textString = text
                    _ = self.isContentValid()
                }
            }
        }
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        if urlString != nil || textString != nil {
            if !contentText.isEmpty {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        // save data to app group via NSUserDefaults
        // so next time we open the app, the app should read value from shared group then generate qrcode as needed
        // as well it needs to erase such data so not to repeat the process every time
        let defaults = UserDefaults(suiteName: SharedConstants.APP_GROUP_IDENTIFIER)
        if defaults != nil {
            let saveString = urlString != nil && urlString != "" ? urlString : textString
            defaults?.set(saveString, forKey: SharedConstants.INPUTTEXT_KEY)
            print("saved input string to app group successfully: " + saveString!)
        }
        else {
            print("saving input string to UserDefaults failed as defaults is nil")
        }
        
        // show complete dialog
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Shared successfully", message: "Open QRCodify app to see the result.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
            }))
            self.present(alert, animated: true)
        }
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        // we can only open containing app in Today widget only, so commented here
//        self.extensionContext!.completeRequest(returningItems: []) { (complete) in
//            // open the containing app
//            let url = URL(string: "abzicoqrcodify://")!
//            self.extensionContext?.open(url, completionHandler: nil)
//        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
