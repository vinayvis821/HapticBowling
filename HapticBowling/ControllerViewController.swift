//
//  ControllerViewController.swift
//  HapticBowling
//
//  Created by Sproull Student on 22/11/22.
//

import UIKit

class ControllerViewController: UIViewController {
    
    var angle: Float!
    @IBOutlet weak var angleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        angle = 0.0
        // Do any additional setup after loading the view.
    }
    @IBAction func bowlButtonFinished(_ sender: Any) {
        print("ball was released")
    }

    @IBAction func bowlButtonBegan(_ sender: Any) {
        print("starting to bowl")
    }
    
    
    // A good range for initial z position is between -423.933 and -421.557
    @IBAction func lateralAdjustLeft(_ sender: Any) {
        print("ball moved left")
    }
    @IBAction func lateralAdjustRight(_ sender: Any) {
        print("ball moved right")
    }
    
    
    //Angle value (z velocity) shouldn't be over 1/20th of x velocity
    //(Not over 4.5 degrees)
    @IBAction func angleAdjustLeft(_ sender: Any) {
        if angle < 4.5 {
            angle += 0.25
            angleLabel.text = "Adjust Angle (\(angle!) degrees)"
        }
    }
    @IBAction func angleAdjustRight(_ sender: Any) {
        if angle > -4.5 {
            angle -= 0.25
            angleLabel.text = "Adjust Angle (\(angle!) degrees)"
        }
    }
    

}
