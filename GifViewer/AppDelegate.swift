//
//  AppDelegate.swift
//  GifViewer
//
//  Created by Theo WU on 17/05/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var masterViewController: MasterViewController!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        masterViewController = MasterViewController(nibName: "MasterViewController", bundle: nil)
        
        masterViewController.setupPages()
        
        window.contentView?.addSubview(masterViewController.view)
        masterViewController.view.frame = window.contentView!.bounds
        
        // 3. Set constraints on masterViewController.view
        masterViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView" : masterViewController.view])
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView" : masterViewController.view])
        NSLayoutConstraint.activateConstraints(verticalConstraints + horizontalConstraints)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        masterViewController.saveCurrentPage()
    }
    
    //click the red dot to close the app, it will not remain in the dock if the function is called
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}

