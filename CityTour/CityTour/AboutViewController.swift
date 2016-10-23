//
//  AboutViewController.swift
//  City Tour
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 23/10/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openLinkedIn(sender: AnyObject) {
        
        if let openLink = NSURL(string: "https://co.linkedin.com/in/juan-andres-cardenas-diaz-50125527") {
            
            UIApplication.sharedApplication().openURL(openLink)
        }
        
    }
    
    
    
    @IBAction func openFacebook(sender: AnyObject) {
        
        let openLink = NSURL(string: "https://www.facebook.com/juanandres.cardenas.735")
        UIApplication.sharedApplication().openURL(openLink!)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
