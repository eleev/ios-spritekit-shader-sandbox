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
    
    // MARK: - Control methods
    
    @discardableResult func updateReflectionIterations(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "iterations", for: value)
    }
    
    @discardableResult func updateRGBLightningEnergyTiming(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "speed", for: value)
    }
    
    @discardableResult func updateSplashIterations(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "u_iterations", for: value)
    }
    
    @discardableResult func updateMandelbrotIterations(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "iterations", for: value)
    }
    
    @discardableResult func updateGTC14(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "iterations", for: value)
    }
    
    @discardableResult func updateCRTRetroEffect(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "u_color_scale", for: value)
    }
    
    @discardableResult func updateLCDPostEffect(for value: Float) -> Bool? {
        return shaderContainer?.shader?.updateUniform(named: "u_color_darkening", for: value)
    }
    
    // MARK: - Container methods
    
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
    
    func splashShader() {
        shaderContainer = createShaderContainer()
        createSplashShader(shaderContainer!)
    }
    
    func tronRoadShader() {
        shaderContainer = createShaderContainer()
        createTronRoad(shaderContainer!)
    }
    
    func mandelbrotRecursive() {
        shaderContainer = createShaderContainer()
        createMandelbroRecursize(shaderContainer!)
    }
    
    func gtc14() {
        shaderContainer = createShaderContainer()
        createGTC14(shaderContainer!)
    }
    
    func LCDPostEffect() {
        shaderContainer = createShaderContainer()
        createLCDPostEffect(shaderContainer!)
    }
    
    func CRTretroEffect() {
        shaderContainer = createShaderContainer()
        createCRTRetroEffect(shaderContainer!)
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
    
    private func createSplashShader(_ shaderContainer: SKSpriteNode, for imageNamed: String = "sand.png") {
        let size = getSceneResolution()
        let u_date = float4([0, 0, 0, Float(arc4random_uniform(70) + 1)])
        
        let splashShader = SKShader(fileNamed: "splash.fsh")
        splashShader.uniforms = [
            SKUniform(name: "u_resolution", vectorFloat3: size),
            SKUniform(name: "u_date", vectorFloat4: u_date),
            SKUniform(name: "u_left_distribution", float: Float.randomFloat(min: 0.125, max: 3.95)),
            SKUniform(name: "u_right_distribution", float: Float.randomFloat(min: 0.125, max: 3.95)),
            SKUniform(name: "u_iterations", float: Float(arc4random_uniform(40) + 8)),
            SKUniform(name: "u_image", texture: SKTexture(imageNamed: imageNamed))
        ]
        shaderContainer.shader = splashShader
    }
    
    private func createTronRoad(_ shaderContainer: SKSpriteNode) {
        let size = getSceneResolution()
        
        let tronRoadShader = SKShader(fileNamed: "tron_road.fsh")
        tronRoadShader.uniforms = [
            SKUniform(name: "u_resolution", vectorFloat3: size)
        ]
        shaderContainer.shader = tronRoadShader
    }
    
    private func createMandelbroRecursize(_ shaderContainer: SKSpriteNode) {
        let size = getSceneResolution()
        let iterations: Float = 64
        
        let tronRoadShader = SKShader(fileNamed: "mandelbrot-recursive.fsh")
        tronRoadShader.uniforms = [
            SKUniform(name: "u_resolution", vectorFloat3: size),
            SKUniform(name: "iterations", float: iterations)
        ]
        shaderContainer.shader = tronRoadShader
    }
    
    private func createGTC14(_ shaderContainer: SKSpriteNode) {
        let size = getSceneResolution()
        let iterations: Float = 100
        
        let tronRoadShader = SKShader(fileNamed: "GTC14-conference.fsh")
        tronRoadShader.uniforms = [
            SKUniform(name: "u_resolution", vectorFloat3: size),
            SKUniform(name: "iterations", float: iterations)
        ]
        shaderContainer.shader = tronRoadShader
    }
    
    private func createLCDPostEffect(_ shaderContainer: SKSpriteNode, for imageNamed: String = "retro.jpg") {
        let size = getSceneResolution()
        
        let waterShader = SKShader(fileNamed: "lcd_post_effect.fsh")
        waterShader.uniforms = [
            SKUniform(name: "u_resolution", vectorFloat3: size),
            SKUniform(name: "u_texture0", texture: SKTexture(imageNamed: imageNamed)),
            SKUniform(name: "u_color_darkening", float: 0.25)
        ]
        shaderContainer.shader = waterShader
    }
    
    private func createCRTRetroEffect(_ shaderContainer: SKSpriteNode, for imageNamed: String = "retro.jpg") {
        let size = getSceneResolution()
        
        let waterShader = SKShader(fileNamed: "crt_retro.fsh")
        waterShader.uniforms = [
            SKUniform(name: "u_resolution", vectorFloat3: size),
            SKUniform(name: "u_texture0", texture: SKTexture(imageNamed: imageNamed)),
            SKUniform(name: "u_color_scale", float: 1.27)
        ]
        shaderContainer.shader = waterShader
    }
    
    // MARK: - Utility methods
    
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

extension Float {
    static func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
}

