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

struct GameImages{
    static let GameBackgroundImage: String = "BackgroundImageSet"
    static let BeginBackgroundImage: String = "MenuImageSet"
    static let EndBackgroundImage: String = "Aliens"
}

class HomeScene: SKScene,SKPhysicsContactDelegate{
    
    //Swipes
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let swipeDownRec = UISwipeGestureRecognizer()
    
    //Game variables
    var IsGameEnded = false
    var previousPoint : CGPoint!
    let spriteNode = SKSpriteNode()
    var screen = SKEmitterNode(fileNamed: "Spark")
    var hole = SKSpriteNode(imageNamed: "HoleImageSet")
    var score = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
    let fireNode = SKSpriteNode(fileNamed: "Fire")
    let returnLabel = SKLabelNode(fontNamed: "Chalkduster")
    var scoreNumber = 0
    
    override func didMove(to view: SKView) {
        
        //Add background
        self.setupBackgroundImage(imageName: GameImages.GameBackgroundImage)
        
        //Set scene world to have gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        //Set custom collision detection delegate
        self.physicsWorld.contactDelegate = self
        
        //Set score label
        self.setupScoreLabel(text: "Score: 0", color: SKColor.white,
                        position: CGPoint(x: self.size.width / 2, y: self.size.height - 100),
                        fontSize: 50)
        
        //Set fire node
        self.setupFireNode()
        
        //Set scene physics body
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        sceneBody.friction = 0
        self.physicsBody = sceneBody
        
        //Set game sprite
        self.setupSpriteNode()
        
        //Set hole
        setupHole()
        
        //Setup gestures
        self.setupGestures()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            //Set first point of touch, this is need when rotate
            previousPoint = (touch as! UITouch).location(in: self.view)
            
            if IsGameEnded {
                
                //Get location of current touch
                let touchLocation = touch.location(in: self)
            
                //Check if touch is on label then return to main screen
                if returnLabel.contains(touchLocation){
                    let reveal = SKTransition.doorsOpenVertical(withDuration: 1)
                    let letsPlay = GameScene(size: self.size)
                    self.view?.presentScene(letsPlay, transition: reveal)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            //Get current point of touch
            let currentPoint = (touch as! UITouch).location(in: self.view)
            
            //Get distance between begin point and end point of touch
            let distance = currentPoint.x - previousPoint.x
            
            previousPoint = currentPoint
            
            //Rotate by distance
            spriteNode.zRotation = spriteNode.zRotation + distance / 100.0
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !IsGameEnded{
            
            //Add sky open effect when add ball
            self.setupBallAddEffect()
            
            //Add ball
            self.setupBallAdd()
        }
    }
    
    /* ----- Collision detection method ----- */
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Ball hit hole
        if (contact.bodyA.node?.name == "Ball" && contact.bodyB.node?.name == "Hole")
        || (contact.bodyB.node?.name == "Ball" && contact.bodyA.node?.name == "Hole"){
            
            //Remove ball from the hole
            let ball = (contact.bodyA.node?.name == "Ball" ? contact.bodyA.node : contact.bodyB.node)
            self.removeChildren(in: [ball!])
            
            //Actions make score bigger then smaller
            let actionMakeBigger = SKAction.scale(by: 2, duration: 1)
            let actionMakeSmaller = SKAction.scale(by: 0, duration: 1)
            
            //Set new position
            let actionSetNewPosition = SKAction.run {
                //Remove hole from scene
                self.hole.removeFromParent()
                
                //Set hole
                self.setupHole()
                
                //Change score number
                self.scoreNumber = self.scoreNumber + 1
                
                //Set new score
                self.score.text = "Score: \(self.scoreNumber)"
                self.score.run(SKAction.sequence([actionMakeBigger, actionMakeBigger.reversed()]))
            }
            
            let actionSequence = SKAction.sequence([actionMakeBigger, actionMakeSmaller, actionSetNewPosition])
            
            //Set score to new position
            hole.run(actionSequence)
        }
        
        //Ball hit fire
        if (contact.bodyA.node?.name == "Ball" && contact.bodyB.node?.name == "Fire")
        || (contact.bodyB.node?.name == "Ball" && contact.bodyA.node?.name == "Fire"){
            
            //Remove ball when hit the fire
            let ball = (contact.bodyA.node?.name == "Ball" ? contact.bodyA.node : contact.bodyB.node)
            self.removeChildren(in: [ball!])
            
            //Remove sprite from scene
            spriteNode.removeFromParent()
            
            //Set explosion position to sprite position
            let bomb = SKEmitterNode(fileNamed: "Explosion")
            bomb?.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.35)
            bomb?.zPosition = 13
            
            //Show end game screen
            let resetGame = SKAction.run {
                
                self.removeAllChildren()
                
                //Set end screen background
                self.setupBackgroundImage(imageName: GameImages.EndBackgroundImage)
                
                //Set result score
                self.setupScoreLabel(text: nil, color: SKColor.cyan,
                                     position: CGPoint(x: self.size.width / 2, y: self.size.height / 2),fontSize: 100)
                
                //Set return label
                self.setupReturnLabel()
                
                //Game over set to true
                self.IsGameEnded = true
                
                //Send score
                self.sendScore(points: self.scoreNumber)
            }
            
            self.addChild(bomb!)
            
            //Set explosion and reset game
            bomb?.run(SKAction.sequence([SKAction.wait(forDuration: 3), resetGame]))
        }
    }
    
    /* ----- Custom setup methods ----- */
    
    func sendScore(points: Int){
        var request = URLRequest(url: URL(string: "https://zorball.herokuapp.com/scores/add")!)
        request.httpMethod = "POST"
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        let postString = "cookieText=Secret&date=" + result + "&points=" + String(points)
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func setupBallAdd(){
        let ball = SKShapeNode(circleOfRadius: 35)
        ball.fillColor = SKColor.cyan
        ball.name = "Ball"
        ball.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.85)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.categoryBitMask = ColliderType.Ball
        self.addChild(ball)
    }
    
    func setupBallAddEffect(){
        screen = SKEmitterNode(fileNamed: "Spark")
        screen?.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.85)
        self.addChild(screen!)
        let actionShow = SKAction.scale(by: 1, duration: 1)
        let actionFadeOut = SKAction.fadeOut(withDuration: 1)
        let actionRemove = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([actionShow, actionFadeOut, actionRemove])
        screen?.run(actionSequence)
    }
    
    func setupReturnLabel(){
        self.returnLabel.fontColor = SKColor.cyan
        self.returnLabel.text = "Tap to return"
        self.returnLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.20)
        self.returnLabel.fontSize = 60
        self.addChild(self.returnLabel)
    }
    
    func setupSpriteNode(){
        spriteNode.color = SKColor.purple
        spriteNode.size = CGSize(width: 250, height: 20)
        spriteNode.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.35)
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.affectedByGravity = false
        spriteNode.physicsBody?.isDynamic = false
        
        self.addChild(spriteNode)
        
        let rotateAction = SKAction.rotate(byAngle: 1, duration: 10)
        
        spriteNode.run(SKAction.repeatForever(rotateAction))
    }
    
    func setupFireNode(){
        fireNode?.size = CGSize(width: self.size.width, height: 30)
        fireNode?.position = CGPoint(x: 100 + (0 * 180), y: 0)
        fireNode?.name = "Fire"
        fireNode?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 200))
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
    }
    
    func setupScoreLabel(text: String?, color: SKColor, position: CGPoint, fontSize: Int){
        if text != nil{
            score.text = text
        }
        score.fontSize = CGFloat(fontSize)
        score.position = position
        score.fontColor = color
        self.addChild(score)
    }
    
    func setupBackgroundImage(imageName: String){
        let background = SKSpriteNode(imageNamed: imageName)
        background.size = self.size
        background.position = CGPoint(x: self.size.width * 0.50, y: self.size.height * 0.50)
        background.zPosition = -1;
        self.addChild(background)
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
    
    //The functions that get called when swiping...
    func swipedRight() {
        
        self.setupPause()
    }
    
    func swipedLeft() {
        
        self.setupPause()
    }
    
    func swipedUp() {
        
        self.setupPause()
    }
    
    func swipedDown() {
        
        self.setupPause()
    }
    
    func setupPause(){
        if !(self.view?.isPaused)!{
            self.view?.isPaused = true
        }else{
            self.view?.isPaused = false
        }
    }
    
    func setupGestures(){
        swipeRightRec.addTarget(self, action: #selector(HomeScene.swipedRight) )
        swipeRightRec.direction = .right
        self.view!.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(HomeScene.swipedLeft) )
        swipeLeftRec.direction = .left
        self.view!.addGestureRecognizer(swipeLeftRec)
        
        
        swipeUpRec.addTarget(self, action: #selector(HomeScene.swipedUp) )
        swipeUpRec.direction = .up
        self.view!.addGestureRecognizer(swipeUpRec)
        
        swipeDownRec.addTarget(self, action: #selector(HomeScene.swipedDown) )
        swipeDownRec.direction = .down
        self.view!.addGestureRecognizer(swipeDownRec)
    }
    
    func getTopScores(){
        var request = URLRequest(url: URL(string: "http://www.thisismylink.com/postName.php")!)
        request.httpMethod = "POST"
        let postString = "id=13&name=Jack"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
}


