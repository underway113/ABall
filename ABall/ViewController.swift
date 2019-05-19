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
    
    //Anti Gravity
    @IBOutlet weak var antiGravity: UIView!
    
    //Gravity Puller
    @IBOutlet weak var gravityPuller: UIView!
    
    
    
    //FinishView
    @IBOutlet weak var finishView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redButton.layer.cornerRadius = redButton.frame.width/2
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
                    if colission && currentData.acceleration.z < 0.5 {
                        AudioServicesPlayAlertSound(1521)
//                        print("HIT")
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                            
                            self.redButton.frame = CGRect(x: (maxWidthScreen-width)/2, y: (maxHeightScreen-height)/2, width: 30, height: 30)
                            self.finishView.frame = CGRect(x: 258, y: 836, width: 156, height: 60)
                            self.lineCollection1[12].frame = CGRect(x: 334, y: 130, width: 5, height: 624)
                            
                        }, completion: { (completed) in
                            print("Done Finishing")
                        })
                    }
                }
                
                
                
                //IF Finish
                let colissionFinish = self.redButton.frame.intersects(self.finishView.frame)
                
                if colissionFinish  {
                    if self.finishView.frame.origin.x == 258 {
                        AudioServicesPlayAlertSound(1519)
                        UIView.animate(withDuration: 4, delay: 0, options: .curveEaseInOut, animations: {
                            
                            self.lineCollection1[12].frame = CGRect(x: 334, y: 130, width: 5, height: 414)
                            
                            self.finishView.frame = CGRect(x: 161, y: 411, width: 92, height: 128)
                            
                        }, completion: { (completed) in
                            print("Done Finishing")
                        })
                    }
                    else if self.finishView.frame.origin.x == 161 {
                        AudioServicesPlayAlertSound(1519)
                        UIView.animate(withDuration: 4, delay: 0, options: .curveEaseInOut, animations: {
                            
                            self.finishView.frame = CGRect(x: 258, y: 836, width: 156, height: 60)
                            
                        }, completion: { (completed) in
                            print("Done Finishing")
                        })
                    }
                }
                //
                
                
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
        let speedExpand:CGFloat = 0.025
        
        var accelX = CGFloat(accel.x)
        var accelY = CGFloat(accel.y)
        let maxAccel:CGFloat = 0.2
        
        //Obstacle Anti Gravity
        let colissionAntiGravity = self.redButton.frame.intersects(self.antiGravity.frame)
        //
        
        //Obstacle Gravity Puller
        let colissionGravityPuller = self.redButton.frame.intersects(self.gravityPuller.frame)
        //
        
        //Colission Anti Gravity
        if colissionAntiGravity {
            print("Anti Grav")
            accelY = accelY + CGFloat(0.35)
        }
        //
        
        //Colission Gravity Puller
        if colissionGravityPuller {
            print("Gravity Pull")
            accelY = accelY - CGFloat(0.35)
        }
        //
        
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
        
        //Move Ball
        UIView.animate(withDuration: 0.2, animations: {
            self.redButton.frame = CGRect(x: newPosX, y: newPosY, width: width + speedExpand, height: height + speedExpand)
            
            self.redButton.layer.cornerRadius = self.redButton.frame.width/2
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

