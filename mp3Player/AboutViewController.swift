//
//  AboutViewController.swift
//  mp3Player2
//
//  Created by Saud Almutlaq on 10/10/2018.
//  Copyright © 2018 saudsoft.com. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBAction func dismissViewController(_ sender: Any) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: true, completion: nil)
            print("cancel")
        }
    }
    
    @IBAction func homeButton(_ sender: AnyObject) {
        open(scheme: "https://www.saudsoft.com")
        //UIApplication.shared.openURL(URL(string: "https://www.saudsoft.com")!)
    }
    
    @IBAction func twitterButton(_ sender: AnyObject) {
        open(scheme: "https://www.twitter.com/saudsoft")
        //UIApplication.shared.openURL(URL(string: "https://www.twitter.com/saudsoft")!)
    }
    
    @IBAction func facebookButton(_ sender: AnyObject) {
        open(scheme: "https://www.facebook.com/saudsoft")
        //UIApplication.shared.openURL(URL(string: "https://www.facebook.com/saudsoft")!)
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
