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
        
        let shaderContainerMovement = createShaderContainer()
        // Create a movement shader from a shader file
        createMovementShader(shaderContainerMovement)
        
        // Createa a relfection shader from a shader file
        let shaderContainerReflection = createShaderContainer()
        createReflectionShader(shaderContainerReflection)
        
        createBeach()

        /*
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
         */
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
    
    private func createShaderContainer(from imageNamed: String = "dummypixel.png") -> SKSpriteNode {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let position = CGPoint(x: width / 2, y: height / 2)
        let size = CGSize(width: width, height: height)
        
        // Create a container sprite for the shader that makes the movement
        let shaderContainer = SKSpriteNode(imageNamed: imageNamed)
        shaderContainer.position = position
        shaderContainer.size = size
        self.addChild(shaderContainer)
        return shaderContainer
    }
    
    private func createMovementShader(_ shaderContainer: SKSpriteNode, for imageNamed: String = "sand.png") {
        let multiplier: CGFloat = 1.5
        let x: Float = Float(self.frame.size.width * multiplier)
        let y: Float = Float(self.frame.size.height * multiplier)
        let movementVector: float3 = float3([x, y, 0])
        
        let moveShader = SKShader(fileNamed: "shader_water_movement.fsh")
        moveShader.uniforms = [
            SKUniform(name: "size", vectorFloat3: movementVector),
            SKUniform(name: "customTexture", texture: SKTexture(imageNamed: imageNamed))
        ]
        shaderContainer.shader = moveShader
    }
    
    private func createReflectionShader(_ shaderContainer: SKSpriteNode) {
        let x: Float = Float(self.frame.size.width)
        let y: Float = Float(self.frame.size.height)
        let reflectionVector: float3 = float3([x, y, 0])
        
        let reflectShader = SKShader(fileNamed: "shader_water_reflection.fsh")
        reflectShader.uniforms = [
            SKUniform(name: "size", vectorFloat3: reflectionVector),
            SKUniform(name: "iterations", float: 3)
        ]
        shaderContainer.shader = reflectShader
    }
    
    private func createBeach() {
        let beach = SKSpriteNode(imageNamed: "beach.png")
        beach.size = self.size
        beach.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addChild(beach)
    }
    
}
