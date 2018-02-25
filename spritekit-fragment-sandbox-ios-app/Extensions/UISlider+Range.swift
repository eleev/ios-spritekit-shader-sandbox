//
//  UISlider+Range.swift
//  PixelShaderDemo
//
//  Created by Astemir Eleev on 29/08/2017.
//  Copyright © 2017 Astemir Eleev. All rights reserved.
//

import UIKit

// MARK: - Adds support for concenience methods for managing allowed ranges without calling all the required methods in the client code
extension UISlider {
    func setAllowedValueRange(min: Float, max: Float) {
        self.minimumValue = min
        self.maximumValue = max
    }
}
