//
//  GameScene.swift
//  FloppyBard
//
//  Created by Julian Nicholls on 14/01/2016.
//  Copyright (c) 2016 Really Big Shoe. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var bird = SKSpriteNode()
    var bkgr = SKSpriteNode()

    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -6.0)

        makeBackground()
        makeFlappingBird()
        makeGround()

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bird.physicsBody!.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func makeBackground() {
        let bgTexture   = SKTexture(imageNamed: "bg.png")

        let moveBG      = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replaceBG   = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let slideBG     = SKAction.repeatActionForever(SKAction.sequence([moveBG, replaceBG]))

        for var idx: CGFloat = 0; idx < 3; ++idx {
            bkgr = SKSpriteNode(texture: bgTexture)

            bkgr.position = CGPoint(x: bgTexture.size().width / 2 + idx * bgTexture.size().width, y: CGRectGetMidY(self.frame))
            bkgr.size.height = self.frame.height

            bkgr.runAction(slideBG)
//            bkgr.zPosition = 0

            self.addChild(bkgr)
        }
    }

    func makeGround() {
        let ground = SKNode()

        ground.position = CGPointMake(CGRectGetMidX(self.frame), 0)
        ground.zPosition = 1
        
        print(self.frame.size.width)

        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1), center: ground.position)
        ground.physicsBody?.dynamic = false

        self.addChild(ground)
    }

    func makeFlappingBird() {
        let birdTextureUp   = SKTexture(imageNamed: "flappy1.png")
        let birdTextureDown = SKTexture(imageNamed: "flappy2.png")

        let wings = SKAction.animateWithTextures([birdTextureUp, birdTextureDown], timePerFrame: 0.1)
        let flap  = SKAction.repeatActionForever(wings)

        bird = SKSpriteNode(texture: birdTextureUp)

        print(CGRectGetMidX(self.frame))
        print(CGRectGetMaxY(self.frame))
        
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame))
        bird.zPosition = 5      // Always on top
        bird.runAction(flap)

        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.dynamic = true

        self.addChild(bird)


    }
}
