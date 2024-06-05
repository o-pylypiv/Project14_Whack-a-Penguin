//
//  WhackSlot.swift
//  Project14
//
//  Created by Olha Pylypiv on 28.03.2024.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    var isVisisble = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        
        cropNode.addChild(charNode)
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisisble {return}
        
        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisisble = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        if let mudEffect = SKEmitterNode(fileNamed: "mudEffect") {
            mudEffect.position.x = charNode.position.x
            mudEffect.position.y = charNode.position.y + 62
            addChild(mudEffect)
            let delay = SKAction.wait(forDuration: 0.5)
            let removeMud = SKAction.run {
                mudEffect.removeFromParent()
            }
            charNode.run(SKAction.sequence([delay, removeMud]))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisisble {return}
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisisble = false
    }
    
    func hit() {
        isHit = true
        
//        let delay = SKAction.wait(forDuration: 0.25)
//        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
//        let notVisible = SKAction.run {
//            [unowned self] in
//            self.isVisisble = false
//        }
        if let mudEffect = SKEmitterNode(fileNamed: "mudEffect") {
            if let smokeEffect = SKEmitterNode(fileNamed: "smokeEffect") {
                //smokeEffect.position = charNode.position
                smokeEffect.position.x = charNode.position.x
                smokeEffect.position.y = charNode.position.y + 40
                addChild(smokeEffect)
                
                mudEffect.position.x = charNode.position.x
                mudEffect.position.y = charNode.position.y - 20
                addChild(mudEffect)
                
                let delay = SKAction.wait(forDuration: 0.25)
                let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
                let notVisible = SKAction.run {
                    [unowned self] in
                    self.isVisisble = false
                }
                let delay2 = SKAction.wait(forDuration: 0.5)
                let removeSmoke = SKAction.run {
                    smokeEffect.removeFromParent()
                }
                let removeMud = SKAction.run {
                    mudEffect.removeFromParent()
                }
                
                charNode.run(SKAction.sequence([delay, hide, notVisible, delay2, removeSmoke, removeMud]))
            }
        }
        
//        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
}
