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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        generateQRCode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        if self.navigationController?.navigationBar != nil {
            let frame = self.navigationController!.navigationBar.frame
            
            DispatchQueue.main.async {
                self.qrcodeImageHeightConstraint.constant = self.qrcodeImageHeightConstraint.constant - frame.height
            }
        }
    }
    
    func generateQRCode() {
        if textInput != nil && textInput != "" {
            // generate qr code
            let genImage = coreGenerateQRCode(from: textInput!)
            
            // get qrcode image, check if it's actually generated
            if genImage != nil {
                qrcodeImage.image = genImage
            }
            else {
                showError(with: .qrcodeGenerationError)
            }
        }
        else {
            showError(with: .inputTextIsNullOrEmpty)
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
}
