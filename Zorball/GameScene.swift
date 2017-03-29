//
//  GameScene.swift
//  Zorball
//
//  Created by David on 3/28/17.
//  Copyright © 2017 David. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var previousPoint : CGPoint!
    let spriteNode = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        let screen = SKEmitterNode(fileNamed: "Spark")
        screen?.position = CGPoint(x: 0, y: 400)
        self.addChild(screen!)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        let range = 1..<5
        for i in range{
            let fireNode = SKSpriteNode(fileNamed: "Fire")
            fireNode?.size = CGSize(width: 1250, height: 30)
            fireNode?.position = CGPoint(x: -450 + (i * 180), y: -700)
            self.addChild(fireNode!)
        }
        
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        sceneBody.friction = 0
        self.physicsBody = sceneBody
        
        
        spriteNode.color = SKColor.red
        spriteNode.size = CGSize(width: 250, height: 20)
        spriteNode.position = CGPoint(x: 20, y: -350)
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
        for touch: AnyObject in touches{
            //let positionOfTouch = touch.location(in: self)
            let ball = SKShapeNode(circleOfRadius: 35)
            ball.fillColor = SKColor.red
            ball.position = CGPoint(x: 0, y: 400)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 35)
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.restitution = 1
            ball.physicsBody?.linearDamping = 0
            self.addChild(ball)
        }
    }
}
