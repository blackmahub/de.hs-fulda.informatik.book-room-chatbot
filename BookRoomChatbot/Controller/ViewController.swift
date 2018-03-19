//
//  ViewController.swift
//  BookRoomChatbot
//
//  Created by mahbub on 3/19/18.
//  Copyright © 2018 Fulda University Of Applied Sciences. All rights reserved.
//

import UIKit
import AVFoundation
import ApiAI

class ViewController: UIViewController {

    let speechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var chipResponse: UILabel!
    @IBOutlet weak var userRequest: UITextField!
    
    @IBAction func sendMessage2Chip(_ sender: UIButton) {
        
        guard let textRequest = userRequest.text else {
            
            return
        }
        
        let request = ApiAI.shared().textRequest()
        request?.query = textRequest
        request?.setMappedCompletionBlockSuccess({ req, res in
            
            let response = res as! AIResponse
            
            if let textResponse = response.result.fulfillment.speech {
                
                self.speechAndText(text: textResponse)
            }
            
        }, failure: { req, err in
            
            print("\nError: " + err!.localizedDescription + "\n")
        })
        
        ApiAI.shared().enqueue(request)
        self.userRequest.text = nil
    }
    
    func speechAndText(text: String) {
        
        let speechUtterance = AVSpeechUtterance(string: text)
        self.speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0,animations: { self.chipResponse.text = text })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

