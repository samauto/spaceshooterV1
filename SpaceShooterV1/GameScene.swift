//
//  GameScene.swift
//  SpaceShooterV1
//
//  Created by Mac on 8/24/16.
//  Copyright (c) 2016 STDESIGN. All rights reserved.
//

import SpriteKit

var player = SKSpriteNode?()
var weapon = SKSpriteNode?()
var enemy = SKSpriteNode?()

var scoreLabel = SKLabelNode?()
var mainLabel = SKLabelNode?()

var fireWeaponRate = 0.2
var weaponSpeed = 0.9

var enemySpeed = 2.1
var enemySpawnRate = 0.6

var isAlive = true

var score = 0


var textColorHUD = UIColor(red:0.95, green: 0.95, blue: 0.95, alpha: 1.0)

struct physicsCategory {
    static let player: UInt32 = 1
    static let enemy: UInt32 = 2
    static let weapon: UInt32 = 3
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = UIColor.purpleColor()

        spawnPlayer()
        spawnScoreLabel()
        spawnMainLabel()
        spawnEnemy()
        fireWeapon()
        randomEnemyTimerSpawn()
        updateScore()
        hideLabel()
        resetVariableOnStart()
        
    }
    // END OF FUNC: didMoveToView
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let touchLocation = touch.locationInNode(self)
            player?.position.x = touchLocation.x
        }
        
    }
    // END OF FUNC: touchesBegan

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            let touchLocation = touch.locationInNode(self)
            
            if isAlive == true {
                player?.position.x = touchLocation.x
                player?.position.y = touchLocation.y
            }
            
            if isAlive == false {
                player?.position.x = -200
            }
        }
    }
    // END OF FUNC: touchesBegan
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if isAlive == false {
            player?.position.x = -200
        }
    
    }
    //END OF FUNC: update

    
    func spawnPlayer() {
        
        player = SKSpriteNode(imageNamed: "Spaceship1")
        player!.position = CGPoint(x:CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        player?.physicsBody = SKPhysicsBody(rectangleOfSize: (player?.size)!)
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.categoryBitMask = physicsCategory.player
        player?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        player?.physicsBody?.dynamic = false
        
        self.addChild(player!)
    
    }
    // END OF FUNC: spawnPlayer
    
    func spawnWeapon() {
        weapon = SKSpriteNode(imageNamed: "Weapon1")
        weapon!.position = CGPoint(x:(player?.position.x)!, y: (player?.position.y)!)
        weapon?.physicsBody = SKPhysicsBody(rectangleOfSize: (weapon?.size)!)
        weapon?.physicsBody?.affectedByGravity = false
        weapon?.physicsBody?.categoryBitMask = physicsCategory.weapon
        weapon?.physicsBody?.contactTestBitMask = physicsCategory.enemy
        weapon?.physicsBody?.dynamic = false
        weapon?.zPosition = -1
        
        let moveForward = SKAction.moveToY(800, duration: weaponSpeed)
        let destroy = SKAction.removeFromParent()
        
        weapon!.runAction(SKAction.sequence([moveForward, destroy]))
        
        self.addChild(weapon!)
    }
    // END OF FUNC: spawnWeapon
    
    func fireWeapon() {
        let fireWeaponTimer = SKAction.waitForDuration(fireWeaponRate)
        
        let spawn = SKAction.runBlock{
            self.spawnWeapon()
        }
        
        let sequence = SKAction.sequence([fireWeaponTimer, spawn])
        
        self.runAction(SKAction.repeatActionForever(sequence))
    }
    // END OF FUNC: fireWeapon
    
    func spawnEnemy() {
        enemy = SKSpriteNode(imageNamed: "Enemy1")
        //let minValue = self.size.width/8
        //let maxValue = self.size.width-40
        //let spawnPoint = UInt32(maxValue - minValue)
        
        enemy!.position = CGPoint(x: Int(arc4random_uniform(1000)+300), y: 1000)

        enemy?.physicsBody = SKPhysicsBody(rectangleOfSize: (enemy?.size)!)
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.categoryBitMask = physicsCategory.enemy
        enemy?.physicsBody?.contactTestBitMask = physicsCategory.weapon
        enemy?.physicsBody?.allowsRotation = false
        enemy?.physicsBody?.dynamic = true
        
        var moveForward = SKAction.moveToY(-100, duration: enemySpeed)
        let destroy = SKAction.removeFromParent()
        
        enemy?.runAction(SKAction.sequence([moveForward, destroy]))
        
        if isAlive == false {
            moveForward = SKAction.moveToY(2000, duration: 1.0)
        }
        
        self.addChild(enemy!)

    }
    // END OF FUNC: spawnEnemy
    
    func spawnExplosion(enemyTemp: SKSpriteNode) {
        
        let explosionEmiiterPath: NSString = NSBundle.mainBundle().pathForResource("explosion", ofType: "sks")!
        
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionEmiiterPath as String) as! SKEmitterNode
        
        explosion.position = CGPoint(x: enemyTemp.position.x, y: enemyTemp.position.y)
        explosion.zPosition = 1
        explosion.targetNode = self
        
        self.addChild(explosion)
        
        let explosionTimerRemove = SKAction.waitForDuration(1.0)
        let removeExplosion = SKAction.runBlock{
            explosion.removeFromParent()
        }
        
        self.runAction(SKAction.sequence([explosionTimerRemove, removeExplosion]))
        
    }
    // END OF FUNC: spawnShipExplosion
    
    func spawnShipExplosion(playerTemp: SKSpriteNode) {
        
        let shipExplosionEmiiterPath: NSString = NSBundle.mainBundle().pathForResource("shipexplode", ofType: "sks")!
        
        let shipExplosion = NSKeyedUnarchiver.unarchiveObjectWithFile(shipExplosionEmiiterPath as String) as! SKEmitterNode
        
        shipExplosion.position = CGPoint(x: playerTemp.position.x, y: playerTemp.position.y)
        shipExplosion.zPosition = 1
        shipExplosion.targetNode = self
        
        self.addChild(shipExplosion)
        
        let shipExplosionTimerRemove = SKAction.waitForDuration(1.0)
        let shipRemoveExplosion = SKAction.runBlock{
            shipExplosion.removeFromParent()
        }
        
        self.runAction(SKAction.sequence([shipExplosionTimerRemove, shipRemoveExplosion]))
        
    }
    // END OF FUNC: spawnShipExplosion
    
    func randomEnemyTimerSpawn() {
        let spawnEnemyTimer = SKAction.waitForDuration(enemySpawnRate)
        
        let spawn = SKAction.runBlock{
            self.spawnEnemy()
        }
        
        let sequence = SKAction.sequence([spawnEnemyTimer, spawn])
        
        self.runAction(SKAction.repeatActionForever(sequence))
    }
    // END OF FUNC: randomEnemyTimerSpawn

    func spawnScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel?.fontSize = 50
        scoreLabel?.fontColor = textColorHUD
        scoreLabel?.position = CGPoint(x: CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+200))
        
        scoreLabel?.text = "Score"
        
        self.addChild(scoreLabel!)
    }
    // END OF FUNC: spawnScoreLabel
    
    func spawnMainLabel() {
        mainLabel = SKLabelNode(fontNamed: "Futura")
        mainLabel?.fontSize = 100
        mainLabel?.fontColor = textColorHUD
        mainLabel?.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        mainLabel?.text = "Start"
        
        self.addChild(mainLabel!)

    }
    // END OF FUNC: spawnMainLabe
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        //Weapon/Enemy Collision
        if ((firstBody.categoryBitMask == physicsCategory.weapon) &&
            (secondBody.categoryBitMask == physicsCategory.enemy) ||
            (firstBody.categoryBitMask == physicsCategory.enemy) &&
            (secondBody.categoryBitMask == physicsCategory.weapon)) {
            
            spawnExplosion(firstBody.node as! SKSpriteNode)
            weaponCollision(firstBody.node as! SKSpriteNode, weaponTemp: secondBody.node as! SKSpriteNode)
        }

        //Player/Enemy Collision
        if ((firstBody.categoryBitMask == physicsCategory.player) &&
            (secondBody.categoryBitMask == physicsCategory.enemy) ||
            (firstBody.categoryBitMask == physicsCategory.enemy) &&
            (secondBody.categoryBitMask == physicsCategory.player)) {
            
            spawnShipExplosion(firstBody.node as! SKSpriteNode)
            playerCollision(firstBody.node as! SKSpriteNode, enemyTemp: secondBody.node as! SKSpriteNode)
        }

    }
    //END OF FUNC: didBeginContact
    
    func weaponCollision(enemyTemp: SKSpriteNode, weaponTemp: SKSpriteNode) {
        enemyTemp.removeFromParent()
        weaponTemp.removeFromParent()
        
        score=score+1
        
        updateScore()
    }
    //END OF FUNC: weaponCollision
    
    func playerCollision(playerTemp: SKSpriteNode, enemyTemp: SKSpriteNode) {
        mainLabel?.fontSize = 50
        mainLabel?.alpha = 1.0
        mainLabel?.text = "Game Over"
        
        player?.removeFromParent()
        //enemy?.removeFromParent()
        //weapon?.removeFromParent()
        
        isAlive = false
        
        waitThenMovetoTitleScene()
        
    }
    //END OF FUNC: playerCollision
    
    func waitThenMovetoTitleScene() {
        let wait = SKAction.waitForDuration(3.0)
        let transition  = SKAction.runBlock{
            self.view?.presentScene(TitleScene(), transition: SKTransition.crossFadeWithDuration(0.3))
        }
        
        let sequence = SKAction.sequence([wait, transition])
        
        self.runAction(SKAction.repeatAction(sequence, count:1))
    
    }
    //END OF FUNC: waitThenMovetoTitleScreen
    
    func updateScore() {
        scoreLabel!.text = "Score: \(score)"
    }
    //END OF FUNC: updateScore
    
    func hideLabel() {
        let wait = SKAction.waitForDuration(3.0)
        let hide = SKAction.runBlock{
            mainLabel?.alpha = 0.0
        }
        
        let sequence = SKAction.sequence([wait, hide])
        
        self.runAction(SKAction.repeatAction(sequence, count:1))
    }
    //END OF FUNC: hideLabel
    
    func resetVariableOnStart() {
        isAlive = true
        score = 0
    }
    //END OF FUNC: resetVariableOnStart
    
    
   }
