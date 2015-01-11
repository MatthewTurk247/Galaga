//
//  GameScene.swift
//  Galaga
//
//  Created by Matthew Turk on 1/10/15.
//  Copyright (c) 2015 Turk Enterprises. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode = SKSpriteNode()
    //var bgImage:SKSpriteNode = SKSpriteNode()
    var lastYieldTimeInterval:NSTimeInterval = NSTimeInterval()
    var lastUpdateTimeInterval:NSTimeInterval = NSTimeInterval()        
    var aliensDestroyed:Int = 0
    let alienCatagory:UInt32 = 0x1 << 1
    let photonTorpedoCatagory:UInt32 = 0x1 << 1
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)*/
    }
    
    override init(size:CGSize) {
        
        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        //bgImage = SKSpriteNode(imageNamed: "space")
        player = SKSpriteNode(imageNamed: "shuttle")
        player.position = CGPointMake(self.frame.width/2, player.size.height/2 + 20)
        //bgImage.position = CGPointMake(self.frame.width/2, self.frame.height/2)
        self.addChild(player)
        //self.addChild(bgImage)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAlien() {
        
        var alien:SKSpriteNode = SKSpriteNode(imageNamed: "alien")
        alien.physicsBody? = SKPhysicsBody()
        alien.physicsBody?.dynamic = true
        alien.physicsBody?.categoryBitMask = alienCatagory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCatagory
        alien.physicsBody?.collisionBitMask = 0
        let minX = alien.size.width/2
        let maxX = self.frame.size.width - alien.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()) % CGFloat(rangeX) + CGFloat(minX)
        alien.position = CGPointMake(position, self.frame.height + alien.size.height)
        self.addChild(alien)
        let minDuration = 2
        let maxDuration = 4
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random()) % Int(rangeDuration) + Int(minDuration)
        
        var actionArray:NSMutableArray = NSMutableArray()
        actionArray.addObject(SKAction.moveTo(CGPointMake(position, -alien.size.height), duration: NSTimeInterval(duration)))
        actionArray.addObject(SKAction.removeFromParent())
        alien.runAction(SKAction.sequence(actionArray))
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate:CFTimeInterval) {
        
        lastYieldTimeInterval += timeSinceLastUpdate
        if (lastYieldTimeInterval > 1) {
            lastYieldTimeInterval = 0
            addAlien()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if (timeSinceLastUpdate > 1) {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
    
    }
}
