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
    let  playButton = SKSpriteNode(imageNamed: "PlayButton")
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "MenuImageSet")
        background.size = self.size
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = 10;
        self.addChild(background)
        
        AddGameLabel(title: "Zorball", position: CGPoint(x: 0, y: self.size.height * 0.25),
                     color: SKColor.white, fontSize: 150)
        AddGameLabel(title: "View Stats", position: CGPoint(x: 0, y: self.size.height * -0.20), color: SKColor.red, fontSize: 80)
        
       
        playButton.size = CGSize(width: self.size.width * 0.5, height: self.size.height * 0.10)
        playButton.position = CGPoint(x: 0, y: 0)
        playButton.zPosition = 11
        playButton.name = "Play"
        self.addChild(playButton)
    }
    
    func AddGameLabel(title: String, position: CGPoint, color: SKColor, fontSize: Int) {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = title
        label.color = color
        label.zPosition = 11
        label.fontSize = CGFloat(fontSize)
        label.position = position
        self.addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let touchLocation = touch.location(in: self)
            if playButton.contains(touchLocation){
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1)
                let letsPlay = HomeScene(size: self.size)
                self.view?.presentScene(letsPlay, transition: reveal)
            }
        }
    }
}
