//
//  GameViewController.swift
//  PixelShaderDemo
//
//  Created by Astemir Eleev on 28/08/2017.
//  Copyright © 2017 Astemir Eleev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum SceneTypes {
    typealias ShaderUniformRange = (min: Float, max: Float)
    
    case rgbLighning
    case waterReflection
    case water
    case paintNoise
    case flame
    case lattice6
    case splash
    case tron_road
    case mandelbrot_recursive
    case gtc14
    case ldc_post_effect
    case crt_retro_effect
    case none
    
    func shaderRange() -> ShaderUniformRange {
        switch self {
        case .none:
            return (min: 0, max: 0)
        case .rgbLighning:
            return (min: 0, max: 80)
        case .water:
            return (min: 0, max: 10)
        case .waterReflection:
            return (min: 0, max: 8)
        case .paintNoise:
            return (min: 0, max: 100)
        case .lattice6:
            return (min: 0, max: 100)
        case .splash:
            return (min: 0, max: 150)
        case .flame:
            return (min: 0, max: 100)
        case .tron_road:
            return (min: 0, max: 200)
        case .mandelbrot_recursive:
            return (min: 0, max: 100)
        case .gtc14:
            return (min: 0, max: 100)
        case .ldc_post_effect:
            return (min: 0, max: 20)
        case .crt_retro_effect:
            return (min: -2, max: 10)
        }
    }
}

class GameViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var skView: SKView!
    
    // MARK: - Properties
    
    var scene: GameScene?
    var currentScene: SceneTypes = .none {
        didSet {
            // requires implementation
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            skView.presentScene(scene)
            
            self.scene = scene as? GameScene
        }
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
        
        // Used for cases when separete interface orientations are supported for differetn types of devices e.g. iPhone or iPad for instance
        /*
         if UIDevice.current.userInterfaceIdiom == .phone {
         return .allButUpsideDown
         } else {
         return .all
         }
         */
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func iterationsSliderAction(_ sender: UISlider) {
        let shaderRange = currentScene.shaderRange()
        sender.setAllowedValueRange(min: shaderRange.min, max: shaderRange.max)
        
        let value = sender.value
        
        switch currentScene {
        case .rgbLighning:
            scene?.updateRGBLightningEnergyTiming(for: value)
        case .waterReflection, .flame:
            scene?.updateReflectionIterations(for: value)
        case .splash:
            scene?.updateSplashIterations(for: value)
        case .mandelbrot_recursive:
            scene?.updateMandelbrotIterations(for: value)
        case .gtc14:
            scene?.updateGTC14(for: value)
        case .crt_retro_effect:
            scene?.updateCRTRetroEffect(for: value)
        case .ldc_post_effect:
            scene?.updateLCDPostEffect(for: value)
        case .tron_road:
            fallthrough
        case .water:
            fallthrough
        case .paintNoise:
            fallthrough
        case .lattice6:
            fallthrough
        case .none:
            break
            
        }
    }
    
    // MARK: - Butto actions
    
    @IBAction func rgbLighningAction(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.rgbLighningEnergy()
        currentScene = .rgbLighning
    }
    
    @IBAction func waterReflectionAction(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.waterReflection()
        currentScene = .waterReflection
    }
    
    @IBAction func waterAction(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.waterMovement()
        currentScene = .water
    }
    
    @IBAction func noisePaintAction(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.paintNoise()
        currentScene = .paintNoise
    }
    
    @IBAction func flameAction(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.flameShader()
        currentScene = .flame
    }
    
    @IBAction func lattice6Action(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.lattice6Shader()
        currentScene = .lattice6
    }
    
    @IBAction func splashAction(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.splashShader()
        currentScene = .splash
    }
    
    @IBAction func jqRaymarching(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.tronRoadShader()
        currentScene = .tron_road
    }
    
    @IBAction func mandelbrotRecursive(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.mandelbrotRecursive()
        currentScene = .mandelbrot_recursive
    }
    
    @IBAction func gtc14(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.gtc14()
        currentScene = .gtc14
    }
    
    @IBAction func LCDPostEffect(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.LCDPostEffect()
        currentScene = .ldc_post_effect
    }
    
    @IBAction func CRTRetroEffect(_ sender: UIButton) {
        scene?.removeAllChildren()
        scene?.CRTretroEffect()
        currentScene = .crt_retro_effect
    }
}

