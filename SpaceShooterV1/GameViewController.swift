//
//  GameViewController.swift
//  SpaceShooterV1
//
//  Created by Mac on 8/24/16.
//  Copyright (c) 2016 STDESIGN. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         let scene = TitleScene(size: view.bounds.size)
                    
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
    }
    // END OF FUNC: viewDidLoad

    override func shouldAutorotate() -> Bool {
        return true
    }
    // END OF FUNC: shouldAutorotate

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    // END OF FUNC: supportedInterfaceOrientations

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    // END OF FUNC: didReceiveMemoryWarning

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    // END OF FUNC: prefersStatusBarHidden
}
// END OF CLASS: GameViewController

