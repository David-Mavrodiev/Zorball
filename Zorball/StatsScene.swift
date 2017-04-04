//
//  StatsScene.swift
//  Zorball
//
//  Created by David on 4/3/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import SpriteKit

class StatsScene: SKScene{
    override func didMove(to view: SKView) {
        addGameLabel(title: "Top 5 scores", position: CGPoint(x: self.size.width / 2, y: self.size.height * 0.95), color: SKColor.white, fontSize: 100, name: "Title")
        
        self.getTopScores()
        
        addGameLabel(title: "<-Return", position: CGPoint(x: self.size.width / 2, y: self.size.height * 0.20), color: SKColor.white, fontSize: 80, name: "Return")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let touchLocation = touch.location(in: self)
            if (self.childNode(withName: "Return")?.contains(touchLocation))!{
                let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1)
                let letsPlay = GameScene(size: self.size)
                self.view?.presentScene(letsPlay, transition: reveal)
            }
        }
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
    
    func getTopScores(){
        // prepare json data
        let json: [String: Any] = ["cookieText": "Secret"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: URL(string: "https://zorball.herokuapp.com/scores/getTop")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let postString = "cookieText=Secret"
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
            
            let array = responseString?.components(separatedBy: ";")
            var height = 0.75
            for res in array!{
                self.addGameLabel(title: res, position: CGPoint(x: self.size.width / 2, y: self.size.height * CGFloat(height))
                    , color: SKColor.red, fontSize: 50, name: "None")
                height = height - 0.10
            }
        }
        task.resume()
    }    
}
