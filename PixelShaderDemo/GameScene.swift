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
    private var shaderContainer: SKSpriteNode?
    private var touch: UITouch?
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {        

        createNode(for: "sand")

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
    
    private func updateFingerPosition(_ position: CGPoint) {
        func clamp(value: CGFloat) -> CGFloat {
            let min: CGFloat = -1.0
            let max: CGFloat = 10.0
            return (value - min) / (max - min)
        }
        
        let positionX = clamp(value: position.x / 100)
        let positionY = clamp(value: position.y / 500)
        
        let point = float2([Float(positionX), Float(positionY)])
        shaderContainer?.shader?.updateUniform(named: "finger", for: point)
        
        debugPrint("finger position: ", positionX, positionY)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        updateFingerPosition(pos)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        updateFingerPosition(pos)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        updateFingerPosition(pos)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
 
    
    // MARK: - Methods
    
    @discardableResult func updateReflectionIterations(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "iterations", for: value)
    }
    
    @discardableResult func updateRGBLightningEnergyTiming(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "speed", for: value)
    }
    
    func waterReflection() {
        let shaderContainerMovement = createShaderContainer()
        createMovementShader(shaderContainerMovement, for: "sand")
        
        shaderContainer = createShaderContainer()
        createReflectionShader(shaderContainer!)
    }

    func waterMovement() {
        shaderContainer = createShaderContainer()
        createWaveShader(shaderContainer!)
    }
    
    func rgbLighningEnergy() {
        shaderContainer = createShaderContainer()
        createLightningShader(shaderContainer!)
    }
    
    func paintNoise() {
        shaderContainer = createShaderContainer()
        createPaintNoiseShader(shaderContainer!)
    }
    
    func flameShader() {
        shaderContainer = createShaderContainer()
        createFlameDistanceShader(shaderContainer!)
    }
    
    func lattice6Shader() {
        shaderContainer = createShaderContainer()
        createTriLattice6Shader(shaderContainer!)
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
        let size = getSceneResolution(multiplier: multiplier)
        
        let moveShader = SKShader(fileNamed: "water_movement.fsh")
        moveShader.uniforms = [
            SKUniform(name: "size", vectorFloat3: size),
            SKUniform(name: "customTexture", texture: SKTexture(imageNamed: imageNamed))
        ]
        shaderContainer.shader = moveShader
    }
    
    private func createReflectionShader(_ shaderContainer: SKSpriteNode) {
        let size = getSceneResolution()
        let iterations: Float = 4
        
        let reflectShader = SKShader(fileNamed: "water_reflection.fsh")
        reflectShader.uniforms = [
            SKUniform(name: "size", vectorFloat3: size),
            SKUniform(name: "iterations", float: iterations)
        ]
        shaderContainer.shader = reflectShader
    }
    
    private func createWaveShader(_ shaderContainer: SKSpriteNode, for imageNamed: String = "sand.png") {
        let size = getSceneResolution()
        
        let waterShader = SKShader(fileNamed: "wave.fsh")
        waterShader.uniforms = [
            SKUniform(name: "size", vectorFloat3: size),
            SKUniform(name: "customTexture", texture: SKTexture(imageNamed: imageNamed))
        ]
        shaderContainer.shader = waterShader
    }
    
    private func createLightningShader(_ shaderContainer: SKSpriteNode) {
        let size = getSceneResolution()
        let speed: Float = 20.0
        
        let lightningShader = SKShader(fileNamed: "lightning.fsh")
        lightningShader.uniforms = [
            SKUniform(name: "resolution", vectorFloat3: size),
            SKUniform(name: "speed", float: speed)
        ]
        shaderContainer.shader = lightningShader
    }
    
    private func createPaintNoiseShader(_ shaderContainer: SKSpriteNode) {
        let size = getSceneResolution()
        let finger = float2([0.23, 0.1])
        
        let paintNoiseShader = SKShader(fileNamed: "paint_noise.fsh")
        paintNoiseShader.uniforms = [
            SKUniform(name: "resolution", vectorFloat3: size),
            SKUniform(name: "finger", vectorFloat2: finger)
        ]
        shaderContainer.shader = paintNoiseShader
    }
    
    private func createFlameDistanceShader(_ shaderContainer: SKSpriteNode) {
        let size = getSceneResolution()
        let iterations: Float = 64.0
        
        let flameShader = SKShader(fileNamed: "flame_raymarching.fsh")
        flameShader.uniforms = [
            SKUniform(name: "resolution", vectorFloat3: size),
            SKUniform(name: "iterations", float: iterations)
        ]
        shaderContainer.shader = flameShader
    }
    
    private func createTriLattice6Shader(_ shaderContainer: SKSpriteNode) {
        let size = getSceneResolution()
        
        let latticeShasder = SKShader(fileNamed: "tri_lattice6.fsh")
        latticeShasder.uniforms = [
            SKUniform(name: "resolution", vectorFloat3: size)
        ]
        shaderContainer.shader = latticeShasder
    }
    
    private func getSceneResolution(multiplier: CGFloat = 1.0) -> float3 {
        let width = Float(self.frame.size.width * multiplier)
        let height = Float(self.frame.size.height * multiplier)
        let size = float3([width, height, 0])
        return size
    }
    
    private func createNode(for name: String) {
        let beach = SKSpriteNode(imageNamed: name)
        beach.size = self.size
        beach.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        self.addChild(beach)
    }
    
}

