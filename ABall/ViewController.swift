//
//  ViewController.swift
//  ABall
//
//  Created by Jeremy Adam on 14/05/19.
//  Copyright © 2019 Underway. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    @IBOutlet weak var redButton: UIView!
    
    //Line Collection
    @IBOutlet var lineCollection1: [UIView]!
    
    
    
    //FinishView
    @IBOutlet weak var finishView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redButton.layer.cornerRadius = 15
        UIApplication.shared.isIdleTimerDisabled = true
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let maxWidthScreen = view.frame.width
        let maxHeightScreen = view.frame.height
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let currentData = data {
                
                //Starting Attribute of the Ball
                let xPos = self.redButton.frame.origin.x
                let yPos = self.redButton.frame.origin.y
                let height = self.redButton.frame.size.height
                let width = self.redButton.frame.size.width
                //
                
                //Call function Move Object
                self.moveObject(xPos, yPos, width, height, currentData.acceleration)
                
                //Loop lineColection 1 that exist in screen
                for line in self.lineCollection1 {
                    let colission = self.redButton.frame.intersects(line.frame)
                    
                    //When Collide
                    if colission {
//                        print("HIT")
                        self.redButton.frame = CGRect(x: (maxWidthScreen-width)/2, y: (maxHeightScreen-height)/2, width: width, height: height)
                    }
                }
                
                
                
            }
            else {
                print(error!)
            }
            
            
        }
        
        
    }
    
    
    func moveObject(_ x:CGFloat, _ y:CGFloat, _ width:CGFloat, _ height:CGFloat, _ accel:CMAcceleration) {
        
        let maxWidthScreen = view.frame.width
        let maxHeightScreen = view.frame.height
        let factorAccel:CGFloat = 200
        
        var accelX = CGFloat(accel.x)
        var accelY = CGFloat(accel.y)
        let maxAccel:CGFloat = 0.2
        
        
        //Line Object
        let line7 = self.lineCollection1[7].frame
        
        //Adjust for maximum Acceleration
        if accelX < -maxAccel {
            accelX = -maxAccel
        }
        else if accelX > 0.2 {
            accelX = 0.2
        }

        if accelY < -0.2 {
            accelY = -0.2
        }
        else if accelY > 0.2 {
            accelY = 0.2
        }
        //
        
        //Adjust position if exceed screen
        var newPosX = x + (accelX * factorAccel)
        var newPosY = y - (accelY * factorAccel)
        
        if newPosX > maxWidthScreen-width {
            newPosX = maxWidthScreen-width
        }
        else if newPosX < 0 {
            newPosX = 0
        }
        
        if newPosY > maxHeightScreen-height {
            newPosY = maxHeightScreen-height
        }
        else if newPosY < self.view.safeAreaInsets.top{
            newPosY = self.view.safeAreaInsets.top
        }
        //
        
        //Move object
        UIView.animate(withDuration: 0.2, animations: {
            self.redButton.frame = CGRect(x: newPosX, y: newPosY, width: width, height: height)
            
            //Move Obstacle Line
            //TODO When "Level 1 Finish"
            self.lineCollection1[7].frame = CGRect(x: line7.origin.x, y: line7.origin.y+10, width: line7.width, height: line7.height)
        })
        //
        
        //Reset Position of Moving Line
        if line7.origin.y > maxHeightScreen  {
            print("Xxx")
            self.lineCollection1[7].frame.origin.y = 0
        }
        //
        
        
        
    }

}

