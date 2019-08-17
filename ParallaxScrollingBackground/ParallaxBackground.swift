//
//  ParallaxBackground.swift
//  ParallaxScrollingBackground
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright © 2016, 2019 Good Doug. All rights reserved.
//

import SpriteKit

class BackgroundSprite: SKSpriteNode {
    var nextSprite: BackgroundSprite? = nil
    var maxX: CGFloat {
        get {
            return self.position.x + self.size.width
        }
    }
    
    /// sets the `nextSprite` pointer and moves the new one to be to the left of this one
    func add(nextSprite: BackgroundSprite) {
        let nextX = maxX
        nextSprite.position = CGPoint(x: nextX, y: self.position.y)
        self.nextSprite = nextSprite
    }
    
    func apply(_ f: (BackgroundSprite)->()) {
        f(self)
        if let next = self.nextSprite {
            next.apply(f)
        }
    }
}

class SimpleParallaxBackground: BackgroundType {
    // MARK: BackgroundType
    var ready: Bool = false
    var xOffset: CGFloat  {
        didSet {
            let diff = oldValue - xOffset
            foregroundSpriteListHead.apply { sprite in
                let foreOffset = diff * self.foregroundOffsetFactor
                sprite.position = CGPoint(x: sprite.position.x + foreOffset, y: sprite.position.y)
            }
            backgroundSpriteListHead.apply { sprite in
                let backOffset = diff * self.backgroundOffsetFactor
                sprite.position = CGPoint(x: sprite.position.x + backOffset, y: sprite.position.y)
            }
            checkOffset()
        }
    }

    /// how far the background moves in relation to the "midground"
    var backgroundOffsetFactor: CGFloat = 0.8
    /// how far the foreground moves in relation to the "midground"
    var foregroundOffsetFactor: CGFloat = 1.4
    
    // MARK: local stuff
    
    // the lists
    private var foregroundSpriteListHead: BackgroundSprite
    private var foregroundSpriteListTail: BackgroundSprite
    private var backgroundSpriteListHead: BackgroundSprite
    private var backgroundSpriteListTail: BackgroundSprite
    
    init(viewSize size: CGSize, foreground: Image, background: Image) {
        let foregroundSize = foreground.size
        let backgroundSize = background.size
        xOffset = 0.0
        
        (head: foregroundSpriteListHead, tail: foregroundSpriteListTail) = SimpleParallaxBackground.generateList(image: foreground, imageSize: foregroundSize, viewSize: size, zPosition: 10.0)
        
        (head: backgroundSpriteListHead, tail: backgroundSpriteListTail) = SimpleParallaxBackground.generateList(image: background, imageSize: backgroundSize, viewSize: size, zPosition: -10.0)
    }
    
    func setup(inScene scene: SKScene) {
        backgroundSpriteListHead.apply { sprite in
            scene.addChild(sprite)
        }
        foregroundSpriteListHead.apply { sprite in
            scene.addChild(sprite)
        }
    }
    
    /// checks whether we need to move the first one to the end to make a seamless background
    private func checkOffset() {
        if foregroundSpriteListHead.maxX < 0.0 {
            (head: foregroundSpriteListHead, tail: foregroundSpriteListTail) = moveHead(head: foregroundSpriteListHead, toTail: foregroundSpriteListTail)
        }
        if backgroundSpriteListHead.maxX < 0.0 {
            (head: backgroundSpriteListHead, tail: backgroundSpriteListTail) = moveHead(head: backgroundSpriteListHead, toTail: backgroundSpriteListTail)
        }
    }
    
    private func moveHead(head: BackgroundSprite, toTail tail: BackgroundSprite) -> (head: BackgroundSprite, tail: BackgroundSprite) {
        let toRecycle = head
        guard let next = toRecycle.nextSprite else { fatalError("Bad list") }
        let newHead = next
        tail.add(nextSprite:toRecycle)
        let newTail = toRecycle
        newTail.nextSprite = nil
        return (head: newHead, tail: newTail)
    }
    
    private static func generateList(image: Image, imageSize: CGSize, viewSize: CGSize, zPosition: CGFloat) -> (head: BackgroundSprite, tail: BackgroundSprite) {
        let howManySprites = Int(ceil(viewSize.width / imageSize.width)) + 2
        //print("sprite count: \(howManySprites)")
        let texture = SKTexture(image: image)
        let spriteListHead = BackgroundSprite(texture: texture, size: imageSize)
        let xOffset = (imageSize.width / 2.0) - (viewSize.width / 2.0)
        let yOffset = (imageSize.height / 2.0)
        // create the first sprite
        spriteListHead.position = CGPoint(x: xOffset, y: yOffset)
        spriteListHead.zPosition = zPosition
        var currentSprite: BackgroundSprite = spriteListHead
        // create the rest of the sprites and attach to the first
        for _ in 1..<howManySprites {
            let next = BackgroundSprite(texture: texture, size: imageSize)
            next.zPosition = zPosition
            currentSprite.add(nextSprite: next)
            currentSprite = next
        }
        return (head: spriteListHead, tail:currentSprite)
    }
}
