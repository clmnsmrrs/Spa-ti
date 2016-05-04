//
//  MenuController.swift
//
//
//  Created by Clemens Morris on 27/04/16.
//  Copyright © 2016 Clemens Morris. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation

class MenuController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var menuselect:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let menuselect = self.setupAudioPlayerWithFile("tick", type: "mp3"){
            self.menuselect = menuselect
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        menuselect?.currentTime = 0.00
        menuselect?.play()
        
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  { // Weird Audio Thing I Copied
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    
}