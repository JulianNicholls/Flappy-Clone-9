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

    enum ColliderType : UInt32 {
        case Bird   = 1
        case Object = 2
    }

    var gameOver = false

    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -6.0)

        makeBackground()
        makeFlappingBird()
        makeGround()

        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("addPipes"), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameOver {

        }
        else {
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 40))
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func didBeginContact(contact: SKPhysicsContact) {
        print("Contact")

        gameOver = true
        self.speed = 0
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

        ground.position = CGPointMake(0, 96)

        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false

        bird.physicsBody?.categoryBitMask       = ColliderType.Object.rawValue
        bird.physicsBody?.contactTestBitMask    = ColliderType.Object.rawValue
        bird.physicsBody?.collisionBitMask      = ColliderType.Object.rawValue

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

        bird.physicsBody?.categoryBitMask       = ColliderType.Bird.rawValue
        bird.physicsBody?.contactTestBitMask    = ColliderType.Object.rawValue
        bird.physicsBody?.collisionBitMask      = ColliderType.Object.rawValue

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

        // Pipe 1

        pipe1 = SKSpriteNode(texture: pipe1Texture)

        pipe1.position = CGPoint(x: CGRectGetMaxX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1Texture.size().height / 2 + gap / 2 + offset)
        pipe1.runAction(moveandRemove)

        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1Texture.size())
        pipe1.physicsBody?.dynamic = false

        pipe1.physicsBody?.categoryBitMask       = ColliderType.Object.rawValue
        pipe1.physicsBody?.contactTestBitMask    = ColliderType.Object.rawValue
        pipe1.physicsBody?.collisionBitMask      = ColliderType.Object.rawValue

        self.addChild(pipe1)

        // Pipe 2

        pipe2 = SKSpriteNode(texture: pipe2Texture)

        pipe2.position = CGPoint(x: CGRectGetMaxX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2Texture.size().height / 2 - gap / 2 + offset)
        pipe2.runAction(moveandRemove)

        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2Texture.size())
        pipe2.physicsBody?.dynamic = false

        pipe2.physicsBody?.categoryBitMask       = ColliderType.Object.rawValue
        pipe2.physicsBody?.contactTestBitMask    = ColliderType.Object.rawValue
        pipe2.physicsBody?.collisionBitMask      = ColliderType.Object.rawValue

        self.addChild(pipe2)
    }
}
