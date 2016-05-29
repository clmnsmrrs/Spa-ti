//
//  ContactController.swift
//  Späti
//
//  Created by Clemens Morris on 03/05/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit



class ContactController: UITableViewController,  MFMailComposeViewControllerDelegate//, SKProductsRequestDelegate, SKPaymentTransactionObserver 

{
//    
//    let productIdentifiers: NSObject = "RemoveAd"
//    var product: SKProduct?
//    var productsArray = Array<SKProduct>()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(productsArray.count)
//        
//        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
//        requestProductData()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    @IBAction func visitWebsite(sender: AnyObject) {
        
        let openit = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            let openLink = NSURL(string : "https://no129blog.wordpress.com/2016/05/26/spaeti-berlin/")
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
    
    
//    @IBAction func removeAds(sender: AnyObject) {
//        if(NSUserDefaults.standardUserDefaults().boolForKey("removead")==false){
//        
//        let actionSheetController = UIAlertController(title: "Remove Ads", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default) { (action) -> Void in
//            let payment = SKPayment(product: self.productsArray[0])
//            SKPaymentQueue.defaultQueue().addPayment(payment)
//            
//        }
//            
//
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
//            
//        }
//        
//        actionSheetController.addAction(buyAction)
//        actionSheetController.addAction(cancelAction)
//        
//        presentViewController(actionSheetController, animated: true, completion: nil)
//        
//        }
//        else{
//            
//            let alertSheetController = UIAlertController(title: "Already Done", message: "You already live in an Ad Free World", preferredStyle: UIAlertControllerStyle.ActionSheet)
//            
//            let cancelAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Cancel) { (action) -> Void in
//                
//            }
//            
//            alertSheetController.addAction(cancelAction)
//            
//            presentViewController(alertSheetController, animated: true, completion: nil)
//            
//            
//        }
//    }
//    
//    func requestProductData()
//    {
//        if SKPaymentQueue.canMakePayments() {
//            let request = SKProductsRequest(productIdentifiers: self.productIdentifiers as! Set<String>)
//            request.delegate = self
//            request.start()
//        } else {
//            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
//                alert.dismissViewControllerAnimated(true, completion: nil)
//                
//                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
//                if url != nil
//                {
//                    UIApplication.sharedApplication().openURL(url!)
//                }
//                
//            }))
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
//                alert.dismissViewControllerAnimated(true, completion: nil)
//            }))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//    }
//    
//    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
//        var products = response.products
//        
//        if (products.count != 0) {
//            for i in 0 ..< products.count
//            {
//                self.product = products[i] as SKProduct
//                self.productsArray.append(product!)
//            }
//        } else {
//            print("No products found")
//        }
//        
//       //products = response.invalidProductIdentifiers
//        
//        for product in products
//        {
//            print("Product not found: \(product)")
//        }
//
//    }
//    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            
//            switch transaction.transactionState {
//                
//            case SKPaymentTransactionState.Purchased:
//                print("Transaction Approved")
//                print("Product Identifier: \(transaction.payment.productIdentifier)")
//                self.deliverProduct(transaction)
//                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
//                
//            case SKPaymentTransactionState.Failed:
//                print("Transaction Failed")
//                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
//            default:
//                break
//            }
//        }
//    }
//    
//    func deliverProduct(transaction:SKPaymentTransaction) {
//        
//        if transaction.payment.productIdentifier == "RemoveAd"
//        {
//            print("Non-Consumable Product Purchased")
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "removead")
//            
//        }
//        
//    }
//    
//    @IBAction func restorePurchase(sender: AnyObject) {
//        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
//        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
//    }
//    
//    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
//        print("Transactions Restored")
//        
//        for transaction:SKPaymentTransaction in queue.transactions {
//            
//            if transaction.payment.productIdentifier == "RemoveAd"
//            {
//                print("Non-Consumable Product Purchased")
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "removead")
//            }
//        }
//        
//        let alert = UIAlertView(title: "Thank You", message: "Your purchase was restored.", delegate: nil, cancelButtonTitle: "OK")
//        alert.show()
//    }

}
