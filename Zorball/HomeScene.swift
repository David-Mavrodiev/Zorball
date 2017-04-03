//
//  HomeScene.swift
//  Zorball
//
//  Created by David on 3/30/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import SpriteKit

struct ColliderType{
    static let Ball: UInt32 = 1
    static let Hole: UInt32 = 2
    static let Fire: UInt32 = 3
}
class HomeScene: SKScene,SKPhysicsContactDelegate{
    let exitCategory: UInt32 = 0x1 << 0
    let ballCategory: UInt32 = 0x1 << 1
    
    var previousPoint : CGPoint!
    let spriteNode = SKSpriteNode()
    var screen = SKEmitterNode(fileNamed: "Spark")
    var hole = SKSpriteNode(imageNamed: "HoleImageSet")
    let score = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
    let fireNode = SKSpriteNode(fileNamed: "Fire")
    var scoreNumber = 0
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "BackgroundImageSet")
        background.size = self.size
        background.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.50)
        background.zPosition = -1;
        self.addChild(background)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.contactDelegate = self
        
        score.text = "Score: 0"
        score.fontSize = 50
        score.position = CGPoint(x: self.size.width / 2, y: self.size.height - 100)
        self.addChild(score)
        
        fireNode?.size = CGSize(width: self.size.width, height: 30)
        fireNode?.position = CGPoint(x: 100 + (0 * 180), y: 0)
        fireNode?.name = "Fire"
        fireNode?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        fireNode?.physicsBody?.affectedByGravity = false
        fireNode?.physicsBody?.isDynamic = false
        fireNode?.physicsBody?.categoryBitMask = ColliderType.Fire
        fireNode?.physicsBody?.collisionBitMask = ColliderType.Ball
        fireNode?.physicsBody?.contactTestBitMask = ColliderType.Ball
        let action1 = SKAction.move(to: CGPoint(x: self.size.width / 2, y: 0), duration: 1)
        let action2 = SKAction.scale(by: 2, duration: 0.5)
        let action3 = SKAction.move(to: CGPoint(x: self.size.width * 0.9, y: 0), duration: 1)
        let action4 = SKAction.move(to: CGPoint(x: 0 + self.size.width * 0.1, y: 0), duration: 1)
        let actionSequence = SKAction.sequence([action1, action2, action2.reversed(), action3, action1, action2, action2.reversed(), action4])
        fireNode?.run(SKAction.repeatForever(actionSequence))
        self.addChild(fireNode!)
        
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        sceneBody.friction = 0
        self.physicsBody = sceneBody
        
        spriteNode.color = SKColor.red
        spriteNode.size = CGSize(width: 250, height: 20)
        spriteNode.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.35)
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.physicsBody?.isDynamic = false
        self.addChild(spriteNode)
        
        let rotateAction = SKAction.rotate(byAngle: 1, duration: 10)
        spriteNode.run(SKAction.repeatForever(rotateAction))
        
        setupHole()
    }
    
    func setupHole(){
        hole = SKSpriteNode(imageNamed: "HoleImageSet")
        hole.size = CGSize(width: self.size.width * 0.15, height: self.size.height * 0.15)
        hole.scale(to: hole.size)
        hole.position = getPositionForHole(size: hole.size)
        hole.name = "Hole"
        hole.zPosition = 15
        hole.physicsBody = SKPhysicsBody(rectangleOf: hole.size)
        hole.physicsBody?.affectedByGravity = false
        hole.physicsBody?.isDynamic = false
        hole.physicsBody?.categoryBitMask = ColliderType.Hole
        hole.physicsBody?.collisionBitMask = ColliderType.Ball
        hole.physicsBody?.contactTestBitMask = ColliderType.Ball
        self.addChild(hole)
    }
    
    func getPositionForHole(size : CGSize) -> CGPoint{
        let randomValue = CGFloat(arc4random()) / 0xFFFFFFFF * self.size.height / 1.5
        
        if drand48() < 0.50{
            let x = 0.0 + size.width / 2
            let y = randomValue
            return CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
        let x = self.size.width - size.width / 2
        let y = randomValue
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            previousPoint = (touch as! UITouch).location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let currentPoint = (touch as! UITouch).location(in: self.view)
            let distance = currentPoint.x - previousPoint.x
            previousPoint = currentPoint
            spriteNode.zRotation = spriteNode.zRotation + distance / 100.0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        screen = SKEmitterNode(fileNamed: "Spark")
        screen?.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.85)
        self.addChild(screen!)
        let actionShow = SKAction.scale(by: 1, duration: 1)
        let actionFadeOut = SKAction.fadeOut(withDuration: 1)
        let actionRemove = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([actionShow, actionFadeOut, actionRemove])
        screen?.run(actionSequence)
        
        let ball = SKShapeNode(circleOfRadius: 35)
        ball.fillColor = SKColor.red
        ball.name = "Ball"
        ball.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.85)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.categoryBitMask = ColliderType.Ball
        self.addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "Ball" && contact.bodyB.node?.name == "Hole")
        || (contact.bodyB.node?.name == "Ball" && contact.bodyA.node?.name == "Hole"){
            //print("Contact detected!")
            let ball = (contact.bodyA.node?.name == "Ball" ? contact.bodyA.node : contact.bodyB.node)
            self.removeChildren(in: [ball!])
            
            let actionMakeBigger = SKAction.scale(by: 2, duration: 1)
            let actionMakeSmaller = SKAction.scale(by: 0, duration: 1)
            let actionSetNewPosition = SKAction.run {
                self.hole.removeFromParent()
                self.setupHole()
                self.scoreNumber = self.scoreNumber + 1
                self.score.text = "Score: \(self.scoreNumber)"
                self.score.run(SKAction.sequence([actionMakeBigger, actionMakeBigger.reversed()]))
            }
            let actionSequence = SKAction.sequence([actionMakeBigger, actionMakeSmaller, actionSetNewPosition])
            
            
            hole.run(actionSequence)
        }
        
        if (contact.bodyA.node?.name == "Ball" && contact.bodyB.node?.name == "Fire")
        || (contact.bodyB.node?.name == "Ball" && contact.bodyA.node?.name == "Fire"){
            let ball = (contact.bodyA.node?.name == "Ball" ? contact.bodyA.node : contact.bodyB.node)
            self.removeChildren(in: [ball!])
            self.removeAllChildren()
            //print(bomb?.size.width)
            //print(bomb?.size.height)
            let bomb = SKSpriteNode(fileNamed: "Explosion")
            bomb?.size = CGSize(width: 100, height: 100)
            bomb?.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            let makeVeryBig = SKAction.scale(by: 100, duration: 25)
            let resetGame = SKAction.run {
            
            }
            self.addChild(bomb!)
            bomb?.run(SKAction.sequence([makeVeryBig, resetGame]))
        }
    }
}


