//
//  ViewController.swift
//  TestVibrate
//
//  Created by Jeremy Adam on 14/05/19.
//  Copyright © 2019 Underway. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreMotion

class ViewController: UIViewController {

    enum direction {
        case top
        case down
        case left
        case right
    }
    
    let factorAccel:CGFloat = 200
    
    let motionManager = CMMotionManager()
    @IBOutlet weak var orangeButton: UIView!
    @IBOutlet weak var blueButton: UIView!
    @IBOutlet weak var redButton: UIView!
    @IBOutlet weak var greenButton: UIView!
    
    @IBOutlet weak var lineLeft1: UIView!
    
    @IBAction func blueButtonPressed(_ sender: Any) {
        AudioServicesPlayAlertSound(1519)
        let color = UIColor(displayP3Red: 0.94, green: 0.96, blue: 0.99, alpha: 1.0)
        blueButton.layer.backgroundColor = color.cgColor
        
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        AudioServicesPlayAlertSound(1520)
    }
    
    @IBAction func greenButtonPressed(_ sender: Any) { AudioServicesPlaySystemSound(1521)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blueButton.layer.cornerRadius = 30
//        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.dragItem(_:)))
        orangeButton.addGestureRecognizer(gesture)
        orangeButton.isUserInteractionEnabled = true
        
    }
    
    @objc func dragItem(_ gesture:UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        if(!self.orangeButton.frame.intersects(self.greenButton.frame)) {
            orangeButton.center = CGPoint(x: orangeButton.center.x + translation.x, y: orangeButton.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.view)
        }
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        let maxWidthScreen = view.frame.width
        let maxHeightScreen = view.frame.height
        
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let currentData = data {
                
//                if currentData.acceleration.x < 0.05 {
//                    self.motionManager.accelerometerUpdateInterval = 0.6
//                }
//                else {
//                    self.motionManager.accelerometerUpdateInterval = 0.1
//                }
                
                let xPos = self.redButton.frame.origin.x
                let yPos = self.redButton.frame.origin.y
                let height = self.redButton.frame.size.height
                let width = self.redButton.frame.size.width
                
//                let colission = self.redButton.frame.intersects(self.lineLeft1.frame)
                
                if xPos >= 0 && currentData.acceleration.x < -0.05 {
//                    AudioServicesPlayAlertSound(1519)
                    self.moveObject(direction.left, xPos, yPos, width, height, currentData.acceleration)
                }
                else if yPos >= 0 && currentData.acceleration.y > 0.05 {
//                    AudioServicesPlayAlertSound(1519)
                    self.moveObject(direction.top, xPos, yPos, width, height, currentData.acceleration)
                }
                else if xPos + width <= maxWidthScreen && currentData.acceleration.x > 0.05 {
//                    AudioServicesPlayAlertSound(1519)
                    self.moveObject(direction.right, xPos, yPos, width, height, currentData.acceleration)
                }
                else if yPos + height <= maxHeightScreen && currentData.acceleration.y < -0.05 {
//                    AudioServicesPlayAlertSound(1519)
                    self.moveObject(direction.down, xPos, yPos, width, height, currentData.acceleration)
                }
                
//                print(currentData.acceleration)
                
                
            }
        }
        
        
    }
    
    
    
    
    func moveObject(_ dir:ViewController.direction, _ x:CGFloat, _ y:CGFloat, _ width:CGFloat, _ height:CGFloat, _ accel:CMAcceleration) {
        
        let maxWidthScreen = view.frame.width
        let maxHeightScreen = view.frame.height
        print(maxHeightScreen, maxWidthScreen)
        print("Move \(dir) x \(x) y \(y)")
        
        var newPosX = x + (CGFloat(accel.x) * self.factorAccel)
        var newPosY = y - (CGFloat(accel.y) * self.factorAccel)
        
        if newPosX > maxWidthScreen-width {
            AudioServicesPlayAlertSound(1519)
            newPosX = maxWidthScreen-width
        }
        else if newPosX < 0 {
            AudioServicesPlayAlertSound(1519)
            newPosX = 0
        }
        
        if newPosY > maxHeightScreen-height {
            AudioServicesPlayAlertSound(1519)
            newPosY = maxHeightScreen-height
        }
        else if newPosY < 0 {
            AudioServicesPlayAlertSound(1519)
            newPosY = 0
        }
        
        
        UIView.animate(withDuration: 0.08, animations: {
            switch dir {
            case .top:
                self.redButton.frame = CGRect(x: x, y: newPosY, width: width, height: height)
                
            case .down:
                self.redButton.frame = CGRect(x: x, y: newPosY, width: width, height: height)
                
            case .left:
                self.redButton.frame = CGRect(x: newPosX, y: y, width: width, height: height)
                
            case .right:
                self.redButton.frame = CGRect(x: newPosX, y: y, width: width, height: height)
                
            }
        })
        
        
        
    }

}

