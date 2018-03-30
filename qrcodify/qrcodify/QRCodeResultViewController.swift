//
//  QRCodeResultViewController.swift
//  qrcodify
//
//  Created by Wasin Thonkaew on 3/27/18.
//  Copyright © 2018 Wasin Thonkaew. All rights reserved.
//

import Foundation
import UIKit

class QRCodeResultViewController : UIViewController {
    
    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var qrcodeImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    var textInput: String?
    private let kPreErrorString: String = "Error, cannot generate QRCode"
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        generateQRCode(complete: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateToGenerateQRCode(notification:)), name: NSNotification.Name(rawValue: SharedConstants.Notification.didReadInputString.rawValue), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SharedConstants.Notification.didReadInputString.rawValue), object: nil)
    }
    
    private func setupUI() {
        if self.navigationController?.navigationBar != nil {
            let frame = self.navigationController!.navigationBar.frame
            
            DispatchQueue.main.async {
                self.qrcodeImageHeightConstraint.constant = self.qrcodeImageHeightConstraint.constant - frame.height
            }
        }
    }
    
    func generateQRCode(complete: (()->Void)?) {
        if textInput != nil && textInput != "" {
            // generate qr code
            let genImage = coreGenerateQRCode(from: textInput!)
            
            // get qrcode image, check if it's actually generated
            if genImage != nil {
                self.qrcodeImage.image = genImage
                complete?()
            }
            else {
                showError(with: .qrcodeGenerationError)
                complete?()
            }
        }
        else {
            showError(with: .inputTextIsNullOrEmpty)
            complete?()
        }
    }
    
    func showError(with type: ErrorMessage) {
        DispatchQueue.main.async {
            // show error message
            self.errorLabel.isHidden = false
            self.errorDescriptionLabel.isHidden = false
            // set description of message
            self.errorDescriptionLabel.text = type.rawValue
        }
    }
    
    func coreGenerateQRCode(from text: String) -> UIImage? {
        let stringData = text.data(using: String.Encoding.isoLatin1)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setValue(stringData, forKey: "inputMessage")
        
        if qrFilter.outputImage == nil {
            return nil
        }
        else {
            // try to convert ciImage to cgImage in order to create UIImage
            let context:CIContext = CIContext.init(options: nil)
            var ciImage = qrFilter.outputImage!
            
            // scale it larger
            let transform = CGAffineTransform(scaleX: 7.0, y: 7.0)
            ciImage = ciImage.transformed(by: transform)
            
            // get cgImage in order to create UIImage
            let cgImage:CGImage = context.createCGImage(ciImage, from: ciImage.extent)!
            
            return UIImage(cgImage: cgImage)
        }
    }
    
    @objc func updateToGenerateQRCode(notification: NSNotification) {
        // get input string from notif
        let userInfo = notification.userInfo!
        // set input string to our textInput
        textInput = (userInfo[SharedConstants.DIDREAD_INPUTSTRING_NOTIFICATION_PARAM_STRING] as! String)
        
        // show loading hud first to give impression of generating a new qrcode
        Util.showHud(view: self.view, text: "Generating a new QRCode")
        
        // delay time to allow a gap of time to generate qr code
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // time to generate a new qrcode
            self.generateQRCode {
                // still wait for a while to let user see a dialog
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    // ok now, hide the hud
                    Util.hideHud(view: self.view)
                })
            }
        }
    }
}
