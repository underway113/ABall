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
import AVFoundation

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
    
    @IBOutlet weak var lineFlagSurprise1: UIView!
    
    //Player for Audio
    var player = AVAudioPlayer()

    //Arrow
    @IBOutlet var leftArrowUpCollection: [UIView]!
    @IBOutlet var rightArrowUpCollection: [UIView]!
    
    @IBOutlet var leftArrowDownCollection: [UIView]!
    
    @IBOutlet var rightArrowDownCollection: [UIView]!
    
    let angleConst:CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Up Arrow Rotate
        for (index, item) in leftArrowUpCollection.enumerated() {
            item.transform = CGAffineTransform(rotationAngle: -angleConst)
            rightArrowUpCollection[index].transform = CGAffineTransform(rotationAngle: angleConst)
        }
        
        //Down Arrow Rotate
        for (index, item) in leftArrowDownCollection.enumerated() {
            item.transform = CGAffineTransform(rotationAngle: angleConst)
            rightArrowDownCollection[index].transform = CGAffineTransform(rotationAngle: -angleConst)
        }
       
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
                    if colission && currentData.acceleration.z < 0.8 {
                        
                        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                            
                            AudioServicesPlayAlertSound(1521)
                            AudioServicesPlaySystemSound(1022)
                            self.redButton.frame = CGRect(x: (maxWidthScreen-width)/2, y: (maxHeightScreen-height)/2, width: 30, height: 30)
                            self.finishView.frame = CGRect(x: 258, y: 836, width: 156, height: 60)
                            self.lineCollection1[12].frame = CGRect(x: 334, y: 130, width: 5, height: 624)
                            
                            self.lineCollection1[9].frame = CGRect(x: 81, y: 539, width: 80, height: 5)
                            self.lineCollection1[4].frame = CGRect(x: 81, y: 130, width: 80, height: 5)
                            self.lineCollection1[6].frame = CGRect(x: 81, y: 355, width: 80, height: 5)
                            
                            
                            self.lineCollection1[5].frame = CGRect(x: 0, y: 231, width: 80, height: 5)
                            self.lineCollection1[13].frame = CGRect(x: 0, y: 446, width: 80, height: 5)
                            self.lineCollection1[10].frame = CGRect(x: 0, y: 629, width: 80, height: 5)
                            
                        }, completion: nil)
                    }
                }
                //
                
                //Suprise Line 1
                if self.redButton.frame.intersects(self.lineFlagSurprise1.frame) && self.finishView.frame.origin.x == 161 && self.lineCollection1[9].frame.origin.y == 539 {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                        let originRightX = self.lineCollection1[9].frame.origin.x
                        let originLeftX = self.lineCollection1[5].frame.origin.x
                        let width = self.lineCollection1[9].frame.width
                        let height = self.lineCollection1[9].frame.height
                        
                        self.lineCollection1[9].frame = CGRect(x: originRightX, y: 787, width: width, height: height)
                        self.lineCollection1[4].frame = CGRect(x: originRightX, y: 378, width: width, height: height)
                        self.lineCollection1[6].frame = CGRect(x: originRightX, y: 603, width: width, height: height)
                        
                        
                        self.lineCollection1[5].frame = CGRect(x: originLeftX, y: 479, width: width, height: height)
                        self.lineCollection1[13].frame = CGRect(x: originLeftX, y: 694, width: width, height: height)
                        self.lineCollection1[10].frame = CGRect(x: originLeftX, y: 877, width: width, height: height)
                        
                    }, completion: nil)
                }
                
                
                //IF Finish
                let colissionFinish = self.redButton.frame.intersects(self.finishView.frame)
                
                if colissionFinish  {
                    self.playSound("fin")
                    if self.finishView.frame.origin.x == 258 {
                        AudioServicesPlayAlertSound(1519)
                        UIView.animate(withDuration: 4, delay: 0, options: .curveEaseInOut, animations: {
                            
                            self.lineCollection1[12].frame = CGRect(x: 334, y: 130, width: 5, height: 414)
                            
                            self.finishView.frame = CGRect(x: 161, y: 411, width: 92, height: 128)
                            
                        }, completion: nil)
                    }
                    else if self.finishView.frame.origin.x == 161 {
                        AudioServicesPlayAlertSound(1519)
                        UIView.animate(withDuration: 4, delay: 0, options: .curveEaseInOut, animations: {
                            
                            self.finishView.frame = CGRect(x: 258, y: 836, width: 156, height: 60)
                            
                        }, completion: nil)
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
        let factorAccel:CGFloat = 150
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
            accelY = accelY + CGFloat(0.35)
        }
        //
        
        //Colission Gravity Puller
        if colissionGravityPuller {
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
            self.lineCollection1[7].frame.origin.y = 0
        }
        //
        
        
        
    }

    func playSound(_ soundName:String) {
        let sound = Bundle.main.path(forResource: soundName, ofType: "mp3")
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            player.play()
        }
        catch {
            print(error)
        }
        
    }
}

