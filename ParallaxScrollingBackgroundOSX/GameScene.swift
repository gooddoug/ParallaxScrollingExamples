//
//  GameScene.swift
//  ParallaxScrollingBackgroundOSX
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright (c) 2016, 2019 Good Doug. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var background: SimpleParallaxBackground!
    
    enum Movement {
        case forward, back, none
        
        var offset: CGFloat {
            switch self {
            case .forward:
                return 2.0
            case .back:
                return -2.0
            case .none:
                return 0.0
            }
        }
        
    }
    
    var movement = Movement.forward
    
    override func didMove(to view: SKView) {
        background = SimpleParallaxBackground(viewSize: self.frame.size, foreground: Image(named: "mountain_fore")!, background: Image(named: "mountain_bkgd")!)
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(myLabel)
        
        background.setup(inScene: self)
        
        let moveBackground = SKAction.customAction(withDuration: 1.0) { _, _ in
            self.background.xOffset = self.background.xOffset + self.movement.offset
        }
        self.run(SKAction.repeatForever(moveBackground))
    }

    override func mouseDown(with event: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = event.location(in: self)
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.position = location;
        sprite.setScale(0.5)
        
        let action = SKAction.rotate(byAngle: CGFloat.pi, duration:1)
        sprite.run(SKAction.repeatForever(action))
        
        self.addChild(sprite)
    }
    
    
    // This is an oversimplification of doing this, a real game would need to handle this more gracefully
    override func keyDown(with event: NSEvent) {
        // a to move back and d to move forward
        guard !shouldAutoscroll else { return }
        let chars = event.characters
        if let oneChar = chars?.first {
            switch oneChar {
            case "a":
                movement = Movement.back
                break
            case "d":
                movement = Movement.forward
                break
            default:
                super.keyDown(with: event)
            }
            
        }
    }
    
    override func keyUp(with event: NSEvent) {
        guard !shouldAutoscroll else { return }
        let chars = event.characters
        if let oneChar = chars?.first {
            switch oneChar {
            case "a":
                movement = Movement.none
                break
            case "d":
                movement = Movement.none
                break
            default:
                super.keyUp(with: event)
            }
            
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    var shouldAutoscroll = true {
        didSet {
            movement = shouldAutoscroll ? Movement.forward : Movement.none
        }
    }
}
