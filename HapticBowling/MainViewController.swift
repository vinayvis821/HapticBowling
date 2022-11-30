//
//  MainViewController.swift
//  HapticBowling
//
//  Created by Sproull Student on 22/11/22.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func createGame(_ sender: Any) {
        let gameVC = self.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        
        navigationController?.pushViewController(gameVC, animated: false)
    }
    
    @IBAction func createController(_ sender: Any) {
        let controllerVC = self.storyboard!.instantiateViewController(withIdentifier: "ControllerViewController") as! ControllerViewController
//        print("This running")
//        print(navigationController)
        navigationController?.pushViewController(controllerVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
