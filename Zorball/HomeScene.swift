//
//  HomeScene.swift
//  Zorball
//
//  Created by David on 3/30/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import SpriteKit

class HomeScene: SKScene{
    var previousPoint : CGPoint!
    let spriteNode = SKSpriteNode()
    var screen = SKEmitterNode(fileNamed: "Spark")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "BackgroundImageSet")
        background.size = self.size
        background.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.50)
        background.zPosition = -1;
        self.addChild(background)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        let fireNode = SKSpriteNode(fileNamed: "Fire")
        fireNode?.size = CGSize(width: self.size.width, height: 30)
        fireNode?.position = CGPoint(x: 100 + (0 * 180), y: 0)
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
        ball.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.85)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        self.addChild(ball)
    }}
