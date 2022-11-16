//
//  Accelerometer.swift
//  Gyro
//
//  Created by Vinay Viswanathan on 11/15/22.
//

import Foundation
import CoreMotion

let motion = CMMotionManager()
var timer: (Any)? = nil

func startAccelerometers() {
   // Make sure the accelerometer hardware is available.
   if self.motion.isAccelerometerAvailable {
      self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
      self.motion.startAccelerometerUpdates()

      // Configure a timer to fetch the data.
      self.timer = Timer(fire: Date(), interval: (1.0/60.0),
            repeats: true, block: { (timer) in
         // Get the accelerometer data.
         if let data = self.motion.accelerometerData {
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z

            // Use the accelerometer data in your app.
         }
      })

      // Add the timer to the current run loop.
      RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
   }
}

static const NSTimeInterval accelerometerMin = 0.01;
- (void)startUpdatesWithSliderValue:(int)sliderValue {
    // Determine the update interval.
    NSTimeInterval delta = 0.005;
    NSTimeInterval updateInterval = accelerometerMin + delta * sliderValue;
    // Create a CMMotionManager object.
    CMMotionManager *mManager = [(APLAppDelegate *)
            [[UIApplication sharedApplication] delegate] sharedManager];
    APLAccelerometerGraphViewController * __weak weakSelf = self;
    // Check whether the accelerometer is available.
    if ([mManager isAccelerometerAvailable] == YES) {
        // Assign the update interval to the motion manager.
        [mManager setAccelerometerUpdateInterval:updateInterval];
        [mManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
               withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [weakSelf.graphView addX:accelerometerData.acceleration.x
                  y:accelerometerData.acceleration.y
                  z:accelerometerData.acceleration.z];
        [weakSelf setLabelValueX:accelerometerData.acceleration.x
                  y:accelerometerData.acceleration.y
                  z:accelerometerData.acceleration.z];
      }];
   }
   self.updateIntervalLabel.text = [NSString stringWithFormat:@"%f", updateInterval];
}
- (void)stopUpdates {
   CMMotionManager *mManager = [(APLAppDelegate *)
            [[UIApplication sharedApplication] delegate] sharedManager];
   if ([mManager isAccelerometerActive] == YES) {
      [mManager stopAccelerometerUpdates];
   }
}
