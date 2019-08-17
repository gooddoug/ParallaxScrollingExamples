//
//  BackgroundType.swift
//  ParallaxScrollingBackground
//
//  Created by Doug Whitmore on 3/19/16.
//  Copyright © 2016 Good Doug. All rights reserved.
//

import SpriteKit

protocol BackgroundType {
    /// update the xOffset to move the background, right now it can only move in the positive direction
    var xOffset: CGFloat { get set }
    
    /// this call allows the background to set itself up in the scene
    func setup(inScene scene: SKScene) -> ()
}
