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
    
    //Scene variables
    let  playButton = SKSpriteNode(imageNamed: "PlayButton")
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.setupBackground()
        
        addGameLabel(title: "Zorball", position: CGPoint(x: 0, y: self.size.height * 0.25),
                     color: SKColor.white, fontSize: 150, name: "ZorballTitle")
        
        addGameLabel(title: "View Stats", position: CGPoint(x: 0, y: self.size.height * -0.20), color: SKColor.red, fontSize: 80, name: "GameStats")
        
        addGameLabel(title: "My Best score: " + getScoreLocal(), position: CGPoint(x: 0, y: self.size.height * -0.35), color: SKColor.red, fontSize: 50, name: "MyBestScore")
        
        self.setupPlayButton()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let touchLocation = touch.location(in: self)
            if playButton.contains(touchLocation){
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1)
                let letsPlay = HomeScene(size: self.size)
                self.view?.presentScene(letsPlay, transition: reveal)
            }
            
            if (self.childNode(withName: "GameStats")?.contains(touchLocation))!{
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1)
                let letsPlay = StatsScene(size: self.size)
                self.view?.presentScene(letsPlay, transition: reveal)
            }
        }
    }
    
    /* Custom setup methods */
    
    func getScoreLocal() -> String{
        let savedValue = UserDefaults.standard.string(forKey: "HighScore")
        if savedValue == nil{
            return "0"
        }else{
          return savedValue!
        }
    }
    
    func setupBackground(){
        let background = SKSpriteNode(imageNamed: "MenuImageSet")
        background.size = self.size
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 10;
        self.addChild(background)
    }
    
    func setupPlayButton(){
        playButton.size = CGSize(width: self.size.width * 0.5, height: self.size.height * 0.10)
        playButton.position = CGPoint(x: 0, y: 0)
        playButton.zPosition = 11
        playButton.name = "Play"
        self.addChild(playButton)
    }
    
    func addGameLabel(title: String, position: CGPoint, color: SKColor, fontSize: Int, name: String) {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = title
        label.fontColor = color
        label.zPosition = 11
        label.fontSize = CGFloat(fontSize)
        label.position = position
        label.name = name
        self.addChild(label)
    }
}
