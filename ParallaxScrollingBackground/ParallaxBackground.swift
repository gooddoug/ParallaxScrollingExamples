//
//  ParallaxBackground.swift
//  ParallaxScrollingBackground
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright © 2016 Good Doug. All rights reserved.
//

import SpriteKit
import GameplayKit

class BackgroundSprite: SKSpriteNode {
    var next: BackgroundSprite? = nil
    var maxX: CGFloat {
        get {
            return self.position.x + self.size.width
        }
    }
    
    /// sets the `next` pointer and moves the new one to be to the left of this one
    func addNext(nx: BackgroundSprite) {
        let nextX = maxX
        nx.position = CGPoint(x: nextX, y: self.position.y)
        next = nx
    }
    
    func apply(f: (BackgroundSprite)->()) {
        f(self)
        if let next = self.next {
            next.apply(f)
        }
    }
    
    func toArray() -> [BackgroundSprite] {
        var current = self
        var val = [self]
        while let c = current.next {
            current = c
            val.append(current)
        }
        return val
    }
}

class SimpleParallaxBackground: GKComponent {
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
    weak var scene: SKScene? = nil
    var backgroundOffsetFactor: CGFloat = 0.8
    var foregroundOffsetFactor: CGFloat = 1.2
    
    // MARK: local stuff
    var viewSize: CGSize
    var foreground: Image
    var foregroundSize: CGSize
    var background: Image
    var backgroundSize: CGSize
    
    var foregroundSpriteListHead: BackgroundSprite
    var foregroundSpriteListTail: BackgroundSprite
    var backgroundSpriteListHead: BackgroundSprite
    var backgroundSpriteListTail: BackgroundSprite
    
    init(viewSize size: CGSize, foreground: Image, background: Image) {
        viewSize = size
        self.foreground = foreground
        self.foregroundSize = self.foreground.size
        self.background = background
        self.backgroundSize = self.background.size
        xOffset = 0.0
        
        (head: foregroundSpriteListHead, tail: foregroundSpriteListTail) = SimpleParallaxBackground.generateList(image: self.foreground, imageSize: self.foregroundSize, viewSize: size, zPosition: 10.0)
        
        (head: backgroundSpriteListHead, tail: backgroundSpriteListTail) = SimpleParallaxBackground.generateList(image: self.background, imageSize: self.backgroundSize, viewSize: size, zPosition: -10.0)
    }
    
    func checkOffset() {
        if foregroundSpriteListHead.maxX < 0.0 {
            (head: foregroundSpriteListHead, tail: foregroundSpriteListTail) = moveHead(foregroundSpriteListHead, toTail: foregroundSpriteListTail)
        }
        if backgroundSpriteListHead.maxX < 0.0 {
            (head: backgroundSpriteListHead, tail: backgroundSpriteListTail) = moveHead(backgroundSpriteListHead, toTail: backgroundSpriteListTail)
        }
    }
    
    private func moveHead(head: BackgroundSprite, toTail tail: BackgroundSprite) -> (head: BackgroundSprite, tail: BackgroundSprite) {
        let toRecycle = head
        guard let next = toRecycle.next else { fatalError("Bad list") }
        let newHead = next
        tail.addNext(toRecycle)
        let newTail = toRecycle
        newTail.next = nil
        return (head: newHead, tail: newTail)
    }
    
    private static func generateList(image image: Image, imageSize: CGSize, viewSize: CGSize, zPosition: CGFloat) -> (head: BackgroundSprite, tail: BackgroundSprite) {
        let howManySprites = Int(ceil(viewSize.width / imageSize.width)) + 2
        print("sprite count: \(howManySprites)")
        let texture = SKTexture(image: image)
        let spriteListHead = BackgroundSprite(texture: texture, size: imageSize)
        let xOffset = (imageSize.width / 2.0) - (viewSize.width / 2.0)
        let yOffset = (imageSize.height / 2.0)
        spriteListHead.position = CGPoint(x: xOffset, y: yOffset)
        spriteListHead.zPosition = zPosition
        var currentSprite: BackgroundSprite = spriteListHead
        for _ in 1..<howManySprites {
            let nextSprite = BackgroundSprite(texture: texture, size: imageSize)
            nextSprite.zPosition = zPosition
            currentSprite.addNext(nextSprite)
            currentSprite = nextSprite
        }
        return (head: spriteListHead, tail:currentSprite)
    }
}
