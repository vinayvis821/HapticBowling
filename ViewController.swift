//
//  ViewController.swift
//  Gyro
//
//  Created by Vinay Viswanathan on 11/15/22.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var theLabel: UILabel!
    let motion = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        motion.startGyroUpdates()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true ) { _ in
            if let data = self.motion.gyroData {
                self.theLabel.text = String( data.rotationRate.x)
            } else {
                print( "No gyro data")
            }
        }
        
    }
    
    func startGyros() {
       if motion.isGyroAvailable {
          self.motion.gyroUpdateInterval = 1.0 / 60.0
          self.motion.startGyroUpdates()

          // Configure a timer to fetch the accelerometer data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                 repeats: true, block: { (timer) in
             // Get the gyro data.
             if let data = self.motion.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z

                // Use the gyroscope data in your app.
             }
          })

          // Add the timer to the current run loop.
          RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
       }
    }

    func stopGyros() {
       if self.timer != nil {
          self.timer?.invalidate()
          self.timer = nil

          self.motion.stopGyroUpdates()
       }
    }
    
   


}

