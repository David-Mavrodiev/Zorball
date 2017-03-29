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
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
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
            let positionOfTouch = touch.location(in: self)
            let ball = SKShapeNode(circleOfRadius: 25)
            ball.fillColor = SKColor.red
            ball.position = positionOfTouch
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.restitution = 1
            ball.physicsBody?.linearDamping = 0
            self.addChild(ball)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            /*let positionInScene = [touch .location(in: spriteNode)]
            fl*/
            let currentPoint = (touch as! UITouch).location(in: self.view)
            let distance = currentPoint.x - previousPoint.x
            previousPoint = currentPoint
            spriteNode.zRotation = spriteNode.zRotation + distance / 100.0
        }
    }
}
