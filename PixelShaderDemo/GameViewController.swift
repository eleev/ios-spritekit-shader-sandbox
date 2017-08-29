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

class GameViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var skView: SKView!
    
    // MARK: - Properties
    
    var scene: GameScene?
    
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
        let value = sender.value
        scene?.updateReflectionIterations(for: value)
    }
}
