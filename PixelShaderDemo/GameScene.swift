//
//  GameScene.swift
//  PixelShaderDemo
//
//  Created by Astemir Eleev on 28/08/2017.
//  Copyright © 2017 Astemir Eleev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        let position = CGPoint(x: width / 2, y: height / 2)
        let size = CGSize(width: width, height: height)
        
        // Create a container sprite for the shader that makes the movement
        let shaderContainerMovement = SKSpriteNode(imageNamed: "dummypixel.png")
        shaderContainerMovement.position = position
        shaderContainerMovement.size = size
        self.addChild(shaderContainerMovement)
        
        // Create a movement shader from a shader file
        let multiplier: CGFloat = 1.5
        let x: Float = Float(self.frame.size.width * multiplier)
        let y: Float = Float(self.frame.size.height * multiplier)
        let movementVector: float3 = float3([x, y, 0])
        
        let shaderMove = SKShader(fileNamed: "shader_water_movement.fsh")
        shaderMove.uniforms = [
            SKUniform(name: "size", vectorFloat3: movementVector),
            SKUniform(name: "customTexture", texture: SKTexture(imageNamed: "sand.png"))
        ]
        shaderContainerMovement.shader = shaderMove
        
        
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // MARK: - Touch handling
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
 
    
    // MARK: - Utility
    
    private func createShanderContainer() -> SKSpriteNode {
        
    }
    
    private func createMovementShader() {
        
    }
    
    private func createReflectionShader() {
        
    }
    
}
