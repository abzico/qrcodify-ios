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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // listen to events changed from UITextField
        textInput.delegate = self
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
}

extension ViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textInput.resignFirstResponder()
        return true
    }
}
