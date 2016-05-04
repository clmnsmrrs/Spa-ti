//
//  ContactController.swift
//  Späti
//
//  Created by Clemens Morris on 03/05/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import MessageUI

class ContactController: UITableViewController,  MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    @IBAction func visitWebsite(sender: AnyObject) {
        
        let openit = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            let openLink = NSURL(string : "http://www.google.com")
            UIApplication.sharedApplication().openURL(openLink!)
            
        }
        
        let ac = UIAlertController(title: "Open Safari?", message: "", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        ac.addAction(openit)
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["clemens.morris@mac.com"])
        mailComposerVC.setSubject("Message from Späti App")
        //mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
