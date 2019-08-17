//
//  AppDelegate.swift
//  ParallaxScrollingBackgroundOSX
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright (c) 2016, 2019 Good Doug. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    let scene = GameScene(fileNamed:"GameScene")
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /* Pick a size for the scene */
        guard let scene = self.scene else { return }
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        
        self.skView!.presentScene(scene)
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView!.ignoresSiblingOrder = true
        
        self.skView!.showsFPS = true
        self.skView!.showsNodeCount = true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    @IBAction func toggleAutoscroll(_ sender: NSButton) {
        guard let scene = self.scene else { return }
        scene.shouldAutoscroll = sender.state == .on
    }
    
}
