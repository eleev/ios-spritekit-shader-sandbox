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

enum Scene {
    typealias ShaderUniformRange = (min: Float, max: Float)
    
    case rgbLighning
    case waterReflection
    case water
    case paintNoise
    case flame
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
            return (min: 0, 100)
        case .flame:
            return (min: 0, 100)
        }
    }
}

class GameViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var skView: SKView!
    
    // MARK: - Properties
    
    var scene: GameScene?
    var currentScene: Scene = .none {
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
            scene.scaleMode = .aspectFit
            
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
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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
        case .water:
            fallthrough
        case .paintNoise:
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
}

