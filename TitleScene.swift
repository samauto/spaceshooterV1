//
//  TitleScene.swift
//  SpaceShooterV1
//
//  Created by Mac on 8/24/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene: SKScene {
    
    var btnPlay: UIButton!
    var gameTitle: UILabel!
    
    var textColorHUD = UIColor(red: (0.95), green: (0.95), blue: (0.95), alpha: 1.0)

    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.purpleColor()
        
        setUpText()
    }
    // END OF FUNC: didMoveToView
    
    func setUpText() {
        btnPlay = UIButton(frame: CGRect(x:100, y:100, width:400, height:100))
        btnPlay.center = CGPoint(x: view!.frame.size.width/2, y:view!.frame.size.width/2)
        btnPlay.titleLabel?.font = UIFont(name: "Futura", size: 150)
        btnPlay.setTitle("PLAY!", forState: UIControlState.Normal)
        btnPlay.setTitleColor(textColorHUD, forState: UIControlState.Normal)
        btnPlay.addTarget(self, action: #selector(TitleScene.playTheGame), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(btnPlay)
        
        
        gameTitle = UILabel(frame: CGRect(x:0, y:0, width: view!.frame.width, height:300))
        
        gameTitle!.textColor = textColorHUD
        gameTitle!.font = UIFont(name: "Future", size: 80)
        gameTitle!.textAlignment = NSTextAlignment.Center
        gameTitle!.text = "PARSEEC SECTOR"
        
        self.view?.addSubview(gameTitle)
    }
    // END OF FUNC: setUpText
    
    func playTheGame() {
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(1.0))
        btnPlay.removeFromSuperview()
        gameTitle.removeFromSuperview()
        
        if let scene = GameScene(fileNamed: "GameScene"){
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    // END OF FUNC: playTheGame
}