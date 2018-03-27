//
//  ViewController.swift
//  qrcodify
//
//  Created by Wasin Thonkaew on 3/27/18.
//  Copyright © 2018 Wasin Thonkaew. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // listen to events changed from UITextField
        textInput.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(beginJourneyForInputString(notification:)), name: NSNotification.Name(rawValue: SharedConstants.Notification.didReadInputString.rawValue), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SharedConstants.Notification.didReadInputString.rawValue), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTouchGenerateButton(_ sender: Any) {
        self.performSegue(withIdentifier: "showQRCodeResultSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier!
        
        if identifier == "showQRCodeResultSegue" {
            // get text input and set it for destination vc
            let targetVC = segue.destination as! QRCodeResultViewController
            targetVC.textInput = textInput.text
        }
    }
    
    @objc func beginJourneyForInputString(notification: NSNotification) {
        // get input string from notif
        let userInfo = notification.userInfo!
        let inputString = userInfo[SharedConstants.DIDREAD_INPUTSTRING_NOTIFICATION_PARAM_STRING] as! String
        
        DispatchQueue.main.async {
            self.textInput.text = inputString
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.generateButton.sendActions(for: UIControlEvents.touchUpInside)
            })
        }
    }
}

extension ViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textInput.resignFirstResponder()
        return true
    }
}
