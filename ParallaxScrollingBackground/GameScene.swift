//
//  GameScene.swift
//  ParallaxScrollingBackground
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright (c) 2016, 2019 Good Doug. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SimpleParallaxBackground(viewSize: self.frame.size, foreground: Image(named: "mountain_fore")!, background: Image(named: "mountain_bkgd")!)
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(myLabel)
        
        background.setup(inScene: self)
        
        let moveBackground = SKAction.customAction(withDuration: 1.0) { _, _ in
            background.xOffset = background.xOffset + 2.0
        }
        self.run(SKAction.repeatForever(moveBackground))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotate(byAngle: CGFloat.pi, duration:1)
            
            sprite.run(SKAction.repeatForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
