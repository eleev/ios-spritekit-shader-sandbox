//
//  SKShader+UniformUpdates.swift
//  PixelShaderDemo
//
//  Created by Astemir Eleev on 29/08/2017.
//  Copyright © 2017 Astemir Eleev. All rights reserved.
//

import Foundation
import SpriteKit


// MARK: - Adds supprot for uniform update methods 
extension SKShader {
    
    @discardableResult func updateUniform(named name: String, for value: Float) -> Bool {
        guard let uniform = self.uniformNamed(name) else { return false }
        uniform.floatValue = value
        update(uniform: uniform, named: name)
        return true
    }
    
    @discardableResult func updateUniform(named name: String, for vector: float2) -> Bool {
        guard let uniform = self.uniformNamed(name) else { return false }
        uniform.vectorFloat2Value = vector
        update(uniform: uniform, named: name)
        return true
    }
    
    @discardableResult func updateUniform(named name: String, for vector: float3) -> Bool {
        guard let uniform = self.uniformNamed(name) else { return false }
        uniform.vectorFloat3Value = vector
        update(uniform: uniform, named: name)
        return true
    }
    
    @discardableResult func updateUniform(named name: String, for texture: SKTexture) -> Bool {
        guard let uniform = self.uniformNamed(name) else { return false }
        uniform.textureValue = texture
        update(uniform: uniform, named: name)
        return true
    }
    
    func update(uniform: SKUniform, named name: String) {
        self.removeUniformNamed(name)
        self.addUniform(uniform)
    }
}
