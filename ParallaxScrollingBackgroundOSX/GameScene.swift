//
//  GameScene.swift
//  ParallaxScrollingBackgroundOSX
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright (c) 2016 Good Doug. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let background = SimpleParallaxBackground(viewSize: self.frame.size, foreground: Image(named: "mountain_fore")!, background: Image(named: "mountain_bkgd")!)
        
        background.backgroundSpriteListHead.apply { sprite in
            self.addChild(sprite)
        }
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        
        background.foregroundSpriteListHead.apply { sprite in
            self.addChild(sprite)
        }
        
        let moveBackground = SKAction.customActionWithDuration(1.0) { _, _ in
            background.xOffset = background.xOffset + 2.0
        }
        self.runAction(SKAction.repeatActionForever(moveBackground))
    }

    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = theEvent.locationInNode(self)
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.position = location;
        sprite.setScale(0.5)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
