//
//  GameScene.swift
//  ParallaxScrollingBackgroundTV
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright (c) 2016 Good Doug. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let background = SimpleParallaxBackground(viewSize: self.frame.size, foreground: Image(named: "mountain_fore")!, background: Image(named: "mountain_bkgd")!)
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        
        background.setupInScene(self)
        
        let moveBackground = SKAction.customActionWithDuration(1.0) { _, _ in
            background.xOffset = background.xOffset + 2.0
        }
        self.runAction(SKAction.repeatActionForever(moveBackground))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
