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
        
        var xOffset: CGFloat {
            switch self {
            case .forward:
                return 2.0
            case .back:
                return -2.0
            case .none:
                return 0.0
            }
        }
        
        var shipDirection: ShipDirection? {
            switch self {
            case .forward:
                return ShipDirection.forward
            case .back:
                return ShipDirection.back
            default:
                return nil
            }
        }
    }
    
    enum ShipDirection {
        case forward, back
        
        var shipRotationValue: CGFloat {
            switch self {
            case .forward:
                return -CGFloat.pi / 2
            case .back:
                return CGFloat.pi / 2
            }
        }
        
        func shipRotation(forYMovement yMovement: YMovement) -> CGFloat {
            return shipRotationValue + (upDownRotationOffset * yMovement.shipRotationOffset)
        }
        
        var upDownRotationOffset: CGFloat {
            switch self {
            case .forward:
                return 1
            case .back:
                return -1
            }
        }
    }
    
    enum YMovement {
        case up, down, none
        
        var yOffset: CGFloat {
            switch self {
            case .up:
                return 2.0
            case .down:
                return -2.0
            case .none:
                return 0.0
            }
        }
        
        var shipRotationOffset: CGFloat {
            switch self {
            case .up:
                return CGFloat.pi / 20
            case .down:
                return -CGFloat.pi / 20
            case .none:
                return 0.0
            }
        }
    }
    
    var movement = Movement.forward {
        didSet {
            if let direction = movement.shipDirection, oldValue != movement {
                shipDirection = direction
            }
        }
    }
    var yMovement = YMovement.none {
        didSet {
            if oldValue != yMovement {
                ship.zRotation = shipDirection.shipRotation(forYMovement: yMovement)
            }
        }
    }
    var shipDirection = ShipDirection.forward
    let ship = SKSpriteNode(imageNamed:"Spaceship")
    
    override func didMove(to view: SKView) {
        background = SimpleParallaxBackground(viewSize: self.frame.size, foreground: Image(named: "mountain_fore")!, background: Image(named: "mountain_bkgd")!)
        
        background.setup(inScene: self)
        
        let moveBackground = SKAction.customAction(withDuration: 1.0) { _, _ in
            self.background.xOffset = self.background.xOffset + self.movement.xOffset
        }
        self.run(SKAction.repeatForever(moveBackground))
        
        ship.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        ship.setScale(0.15)
        ship.zRotation = shipDirection.shipRotation(forYMovement: yMovement)
        self.addChild(ship)
    }

    override func mouseDown(with event: NSEvent) {
        /* Called when a mouse click occurs */
        
//        let location = event.location(in: self)
//
//        let sprite = SKSpriteNode(imageNamed:"Spaceship")
//        sprite.position = location;
//        sprite.setScale(0.5)
//
//        let action = SKAction.rotate(byAngle: CGFloat.pi, duration:1)
//        sprite.run(SKAction.repeatForever(action))
//
//        self.addChild(sprite)
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
                ship.zRotation = shipDirection.shipRotation(forYMovement: yMovement)
                break
            case "d":
                movement = Movement.forward
                ship.zRotation = shipDirection.shipRotation(forYMovement: yMovement)
                break
            case "s":
                yMovement = YMovement.down
                break
            case "w":
                yMovement = YMovement.up
                break
            default:
                super.keyDown(with: event)
            }
            //
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
            case "s":
                yMovement = YMovement.none
                break
            case "w":
                yMovement = YMovement.none
                break
            default:
                super.keyUp(with: event)
            }
            
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let currentPosition = ship.position
        let max = self.frame.size.height
        let newY = currentPosition.y + yMovement.yOffset
        if newY < max && newY > 50 {
            let newPosition = CGPoint(x: currentPosition.x, y: newY)
            ship.position = newPosition
        }
    }
    
    var shouldAutoscroll = true {
        didSet {
            movement = shouldAutoscroll ? Movement.forward : Movement.none
        }
    }
}
