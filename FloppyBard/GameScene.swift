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

    override func didMoveToView(view: SKView) {
        let birdTexture = SKTexture(imageNamed: "flappy1.png")

        bird = SKSpriteNode(texture: birdTexture)

        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))

        self.addChild(bird)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}