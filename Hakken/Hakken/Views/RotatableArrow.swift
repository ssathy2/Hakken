//
//  SubcommentsVisibleIndicator.swift
//  Hakken
//
//  Created by Sidd Sathyam on 11/30/15.
//  Copyright © 2015 dotdotdot. All rights reserved.
//

import UIKit

@objc enum ArrowDirection : Int {
    case ArrowDirectionNone = -1
    case ArrowDirectionUp = 0
    case ArrowDirectionDown = 1
    case ArrowDirectionLeft = 2
    case ArrowDirectionRight = 3
}

class RotatableArrow : UIView {
    private var direction : ArrowDirection = ArrowDirection.ArrowDirectionNone
    private var arrowLayer : CAShapeLayer?
    private var arrowBezierPath : UIBezierPath?

    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        if (arrowLayer == nil) {
            self.setupArrowLayer()
        }
    }
    
    private func setupArrowLayer() {
        self.arrowLayer = CAShapeLayer()
        var arrowLayerFrame = self.bounds
        arrowLayerFrame.origin.x += 2
        arrowLayerFrame.origin.y += 2
        arrowLayerFrame.size.height -= 2
        arrowLayerFrame.size.width -= 2
        self.arrowLayer!.frame = arrowLayerFrame
        self.updateLayer(ArrowDirection.ArrowDirectionNone, newDirection: ArrowDirection.ArrowDirectionUp, animated: false, clockwise: true)
    }
    
    func setDirection(newDirection: ArrowDirection, animated: Bool, clockwise: Bool) {
        if (direction != newDirection)
        {
            // animate the direction changing here
            self.updateLayer(direction, newDirection: newDirection, animated: animated, clockwise: clockwise)
            // update the stored direction with newDirection
            direction = newDirection
        }
    }
    
    private func updateLayer(oldDirection: ArrowDirection, newDirection: ArrowDirection, animated: Bool, clockwise: Bool) {
        // 1. the old direction is the same as newdirection, so we do nothing here...
        // 2. the old direction is different from the new direction ->
            // if the bezier path property is nil, we're drawing for the first time
            // create the bezier path and set it equal to the path property on the shapelayer
        // 3. animate the rotation of the layer from oldDirection to newDirection
            // derive the angle of rotation from the oldDirection to newDirection AND clockwise param
    }
    
    
}