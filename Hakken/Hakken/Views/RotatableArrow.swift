//
//  SubcommentsVisibleIndicator.swift
//  Hakken
//
//  Created by Sidd Sathyam on 11/30/15.
//  Copyright © 2015 dotdotdot. All rights reserved.
//

import UIKit

@objc enum ArrowDirection : Int {
    case ArrowDirectionDown = 0
    case ArrowDirectionRight = 1
}

class RotatableArrow : UIView {
    private var direction : ArrowDirection = ArrowDirection.ArrowDirectionDown
    private var arrowLayer : CAShapeLayer?
    private var arrowBezierPath : UIBezierPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupArrowLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateArrowLayer(self.bounds)
    }
    
    private func updateArrowLayer(var newFrame: CGRect) {
        newFrame.origin.x += 2
        newFrame.origin.y += 2
        newFrame.size.height -= 2
        newFrame.size.width -= 2
        self.arrowLayer!.frame = newFrame
        self.arrowLayer!.lineWidth = 1.0
        self.arrowLayer!.strokeColor = UIColor.grayColor().CGColor
        self.updateArrowBezierPath(self.arrowLayer!.bounds)
    }
    
    private func updateArrowBezierPath(newFrame: CGRect) {
        self.arrowBezierPath = UIBezierPath.init()
        let startPoint = CGPointZero
        self.arrowBezierPath!.moveToPoint(startPoint)
        self.arrowBezierPath!.addLineToPoint(CGPointMake(CGRectGetMidX(newFrame), CGRectGetMaxY(newFrame)))
        self.arrowBezierPath!.addLineToPoint(CGPointMake(CGRectGetMaxX(newFrame), CGRectGetMinY(newFrame)))
        self.arrowBezierPath!.closePath()
        self.arrowLayer!.path = self.arrowBezierPath!.CGPath
    }
    
    private func setupArrowLayer() {
        self.arrowLayer = CAShapeLayer()
        self.arrowLayer!.anchorPoint = CGPointMake(0.5, 0.5);
        self.updateArrowLayer(self.bounds)
        self.updateArrowBezierPath(self.arrowLayer!.bounds)
        self.layer.addSublayer(self.arrowLayer!)
    }       
    
    func setDirection(newDirection: ArrowDirection, animated: Bool) {
        if (direction != newDirection)
        {
            // animate the direction changing here
            self.updateLayer(direction, newDirection: newDirection, animated: animated)
            // update the stored direction with newDirection
            direction = newDirection
        }
    }
    
    private func updateLayer(oldDirection: ArrowDirection, newDirection: ArrowDirection, animated: Bool) {
        // if the bezier path property is nil, we're drawing for the first time
        if (self.arrowLayer == nil)
        {
            self.setupArrowLayer()
        }
        
        let totalRotations = (newDirection.rawValue - oldDirection.rawValue) * -1
        // figure out how many radians to rotate layer by
        let CGRotationTransform = CGAffineTransformRotate(CATransform3DGetAffineTransform(self.arrowLayer!.transform), CGFloat(Double(totalRotations) * M_PI_2))
        let rotationTransform = CATransform3DMakeAffineTransform(CGRotationTransform)
        let transformClosure = {
            self.arrowLayer!.transform = rotationTransform
        }
        
        // 3. animate the rotation of the layer from oldDirection to newDirection
            // derive the angle of rotation from the oldDirection to newDirection AND clockwise param
        if (animated)
        {
            UIView.animateWithDuration(0.2, animations: transformClosure)
        }
        else
        {
            transformClosure()
        }
    }
    
    
}