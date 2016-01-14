//
//  GameScene.swift
//  FloppyBard
//
//  Created by Julian Nicholls on 14/01/2016.
//  Copyright (c) 2016 Really Big Shoe. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var bird = SKSpriteNode()
    var bkgr = SKSpriteNode()

    override func didMoveToView(view: SKView) {

        makeBackground()
        makeFlappingBird()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
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
            bkgr.zPosition = 0

            self.addChild(bkgr)
        }
    }

    func makeFlappingBird() {
        let birdTextureUp   = SKTexture(imageNamed: "flappy1.png")
        let birdTextureDown = SKTexture(imageNamed: "flappy2.png")

        let wings = SKAction.animateWithTextures([birdTextureUp, birdTextureDown], timePerFrame: 0.1)
        let flap  = SKAction.repeatActionForever(wings)

        bird = SKSpriteNode(texture: birdTextureUp)

        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(flap)
        bird.zPosition = 4      // Always on top

        self.addChild(bird)
    }
}
