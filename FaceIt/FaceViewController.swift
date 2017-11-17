//
//  ViewController.swift
//  FaceIt
//
//  Created by Sung Kim on 10/23/17.
//  Copyright © 2017 Sung Kim. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController
{
    @IBOutlet weak var faceView: FaceView!
    {
        didSet
        {
            //let handler = #selector(FaceView.changeScale(byReactingTo:))
            //let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            //faceView.addGestureRecognizer(pinchRecognizer)
            //let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleEyes(byReactingTo: )))
            //tapRecognizer.numberOfTapsRequired = 1
            //faceView.addGestureRecognizer(tapRecognizer)
            
            //let swipUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            //swipUpRecognizer.direction = .up
            //faceView.addGestureRecognizer(swipUpRecognizer)
            
            //let swipDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            //swipDownRecognizer = .down
            //faceView.addGestureRecognizer(swipDownRecognizer)
            
            updateUI()
        }
    }
    
    private struct HeadShake
    {
        static let angle = CGFloat.pi/6     // radians
        static let segmentDuration: TimeInterval = 0.5  // each head shake has 3 segments
        
    }
    
    private func rotateFace(by angle: CGFloat)
    {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead()
    {
        UIView.animate(
            withDuration: HeadShake.segmentDuration,
            animations: {self.rotateFace(by: HeadShake.angle)},
            completion: { finished in
                if finished {
                    UIView.animate(
                        withDuration: HeadShake.segmentDuration,
                        animations: { self.rotateFace(by: -HeadShake.angle*2) },
                        completion: { finished in
                            if finished {
                                UIView.animate(
                                    withDuration: HeadShake.segmentDuration,
                                    animations: {self.rotateFace(by:HeadShake.angle) }
                                )
                            }
                        }
                    )
                }
            }
        )
    }
    
    @IBAction func shakeHead(_ sender: UITapGestureRecognizer)
    {
        shakeHead()
    }
    
    
    func increaseHappiness()
    {
        expression = expression.happier
    }
    
    func decreaseHappiness()
    {
        expression = expression.sadder
    }
    
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer)
    {
        if tapRecognizer.state == .ended
        {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    var expression = FacialExpression(eyes: .open, mouth: .grin)
    {
        // if vars change
        // property observer
        // if externally changed, then didSet kicks in
        didSet
        {
            updateUI()
        }
    }
    
    func updateUI()
    {
        switch expression.eyes
        {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
//            faceView?.eyesOpen = false
            break
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin: 0.5, .frown: -1.0, .smile: 1.0, .neutral: 0.0, .smirk: -0.5]
    
}

