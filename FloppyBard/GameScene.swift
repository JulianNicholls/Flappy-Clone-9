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

    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()

    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -6.0)

        makeBackground()
        makeFlappingBird()
        makeGround()

        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("addPipes"), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        bird.physicsBody!.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 40))
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
            bkgr.zPosition = -5

            self.addChild(bkgr)
        }
    }

    func makeGround() {
        let ground = SKNode()

        ground.position = CGPointMake(0, 90)

        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false

        self.addChild(ground)
    }

    func makeFlappingBird() {
        let birdTextureUp   = SKTexture(imageNamed: "flappy1.png")
        let birdTextureDown = SKTexture(imageNamed: "flappy2.png")

        let wings = SKAction.animateWithTextures([birdTextureUp, birdTextureDown], timePerFrame: 0.1)
        let flap  = SKAction.repeatActionForever(wings)

        bird = SKSpriteNode(texture: birdTextureUp)

        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame))
        bird.runAction(flap)

        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.dynamic = true

        self.addChild(bird)
    }

    func addPipes() {
        let pipe1Texture    = SKTexture(imageNamed: "pipe1.png")
        let pipe2Texture    = SKTexture(imageNamed: "pipe2.png")
        let gap             = bird.size.height * 3
        let updown          = CGFloat(arc4random() % UInt32(self.frame.size.height / 2))
        let offset          = updown - self.frame.size.height / 4

        let movePipes       = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        let removePipes     = SKAction.removeFromParent()
        let moveandRemove   = SKAction.sequence([movePipes, removePipes])

        pipe1 = SKSpriteNode(texture: pipe1Texture)
        pipe2 = SKSpriteNode(texture: pipe2Texture)

        pipe1.position = CGPoint(x: CGRectGetMaxX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1Texture.size().height / 2 + gap / 2 + offset)
        pipe2.position = CGPoint(x: CGRectGetMaxX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height / 2 - gap / 2 + offset)

        pipe1.runAction(moveandRemove)
        pipe2.runAction(moveandRemove)

        self.addChild(pipe1)
        self.addChild(pipe2)
    }
}
