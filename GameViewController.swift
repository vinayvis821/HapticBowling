//
//  GameViewController.swift
//  hapticBowling
//
//  Created by Anton Young on 11/11/22.
//

import UIKit
import SceneKit
import AVFoundation

class GameViewController: UIViewController, SCNPhysicsContactDelegate {
    var scnView: SCNView!
    var bowlingBall : SCNNode!
    var bowlingLane : SCNNode!
    var bowlingPin : SCNNode!
    var cameraNode : SCNNode!
    
    //Is the ball rolling? Must be false before it can be rolled again
    var ballStatus : Bool?
    
    var initialPinLocations: [SCNVector3]!
    var scnScene: SCNScene?
    var newPinLocations: [SCNVector3]!
    var pins:[SCNNode]!
    var ballLocation:SCNVector3!
    //This keeps track of what pins are standing
    var standingPins = [true,true,true,true,true,true,true,true,true,true]
    
    //These will be set from lobby add/remove players list
    var players:[Scoring]?
    var anton = Scoring(playerName: "Anton")
    var mac = Scoring(playerName: "Mac")
    var currentPlayer = 0
    var soundPlayer: AVAudioPlayer?
    
    var didCollide:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "didCollide")
        players = [anton, mac]
        pins = []
        didCollide = false
        ballStatus = false
        initialPinLocations = []
        newPinLocations = []
        setupView()
        setupScene()
        setupCamera()
    }
    
    func setupView() {
        scnView = self.view as? SCNView
        scnView.delegate = self
        scnScene = SCNScene(named: "BowlingAlley.scn")
        //scnView.debugOptions = [.showPhysicsShapes, .showConstraints]
        scnView.scene = scnScene
        scnScene!.physicsWorld.gravity = SCNVector3Make(0, -4, 0)
        scnScene!.physicsWorld.contactDelegate = self
    }
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zNear = 1
        cameraNode.camera?.zFar = 600
        cameraNode.camera?.fieldOfView = 100000
        cameraNode.eulerAngles = SCNVector3Make(Float.pi, Float.pi / 2, 0)
        cameraNode.position = SCNVector3(x: bowlingBall.position.x, y: 5, z: bowlingBall.position.z - 10)
        scnScene!.rootNode.addChildNode(cameraNode)
        //print("Camera", cameraNode.position)
        //print("Bowlingball", bowlingBall.position)
        scnView.pointOfView = cameraNode
    }
    func setupScene() {
        
        for node in scnScene!.rootNode.childNodes {
            if node.name == "bowlinglane" {
                //print("lane found")
                bowlingLane = node
                bowlingLane.physicsBody = SCNPhysicsBody(type: .kinematic, shape:nil)
                
                //Don't change this, helps the ball curve
                bowlingLane.physicsBody?.friction = 1
 //               bowlingLane.physicsBody?.rol
                bowlingLane.physicsBody?.categoryBitMask = 1
                //bowlingLane.physicsBody?.collisionBitMask = 2
            }
            if node.name == "bowlingpin" {
                bowlingPin = node
                pins.append(node)
                //Each should be 5
                
                //Every pin is standing
               // print(standingPins)
            }
            bowlingBall = scnScene!.rootNode.childNode(withName: "bowlingball", recursively: false)!
            //bowlingBall.geometry?.material(named: "bowlingBall")
           bowlingBall.physicsBody = SCNPhysicsBody(type: .dynamic, shape:SCNPhysicsShape(geometry: SCNSphere(radius: 0.4)))
            
            bowlingBall.physicsBody?.friction = 0.01
            bowlingBall.physicsBody?.rollingFriction = 0.01
            bowlingBall.physicsBody?.damping = 0.01
            bowlingBall.physicsBody?.mass = 4
            //4,9
            bowlingBall.physicsBody?.contactTestBitMask = 1
            bowlingBall.physicsBody?.collisionBitMask = 7
            bowlingBall.physicsBody?.categoryBitMask = 9
            //bowlingBall.physicsBody?.isAffectedByGravity = false
            ballLocation = bowlingBall.position
            
            for i in 0..<pins.count {
                // If the pin is set as standing, assign a physics body to it
                if standingPins[i] {
                    bowlingPin.physicsBody = SCNPhysicsBody(type: .dynamic, shape:nil)
    //
                    bowlingPin.physicsBody?.mass = 1
    //                bowlingPin.physicsBody?.friction = 0.01
                    bowlingPin.physicsBody?.centerOfMassOffset = SCNVector3(0,0.9,0)
    //                bowlingPin.physicsBody?.rollingFriction = 0.01
    //                bowlingPin.physicsBody?.angularDamping = 0.01
                    bowlingPin.physicsBody?.restitution = 0.65
                    bowlingPin.physicsBody?.isAffectedByGravity = true
                    bowlingPin.physicsBody?.contactTestBitMask = 1
                    bowlingPin.physicsBody?.categoryBitMask = 6
                    bowlingPin.physicsBody?.collisionBitMask = 3
                } else {
                    pins[i].physicsBody = nil
                    pins[i].isHidden = true
                }
            }
        }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: #selector(GameViewController.sceneViewTapped(recognizer:)))
        scnView.addGestureRecognizer(tapRecognizer)
       // print(bowlingBall.position)
    }
    
    func childNode(withName name: String, recursively: Bool) -> SCNNode? {
        return SCNNode()
    }

    @objc func sceneViewTapped(recognizer: UITapGestureRecognizer){
        //print("this is runnin")
        //let position = SCNVector3(x: bowlingBall.position.x, y: bowlingBall.position.y, z: bowlingBall.position.z)
        //Negative values to the x coordinate of torque makes ball curve left
        //Positive values curve right
        if ballStatus == false {
            let torque = SCNVector4Make(14,0,0,1)
            let force = SCNVector3Make(8, 0, 0)
            bowlingBall.physicsBody!.velocity = force
            //bowlingBall.physicsBody!.applyTorque(torque, asImpulse: true)
            bowlingBall.physicsBody!.angularVelocity = torque
            //print(bowlingBall.presentation.position)
            ballStatus = true
            
        //getting initial pin positions
        for node in scnScene!.rootNode.childNodes {
            if node.name == "bowlingpin" {
                initialPinLocations!.append(node.position)
                    
            }
        }
    }
    
        

    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    func getMovedPins() -> Int {
        var sum = 0
        for node in scnScene!.rootNode.childNodes {
            if node.name == "bowlingpin" {
                newPinLocations?.append(node.presentation.position)
            }
        }
        for i in 0..<initialPinLocations!.count {
            let initial = initialPinLocations![i]
            let final = newPinLocations![i]
            let difference = subtractVector(vector1: initial, vector2: final)
            //print("DIFFERENCE ", difference)
            
            if getPinMoved(vector: difference) {
                sum += 1
                standingPins[i] = false
            }
            
        }
        return sum
    }
//    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact){
//     }
}
func subtractVector(vector1: SCNVector3, vector2: SCNVector3) -> SCNVector3 {
    var newVector = SCNVector3Make(0,0,0)
    newVector.x = vector1.x - vector2.x
    newVector.y = vector1.y - vector2.y
    newVector.z = vector1.z - vector2.z
    return newVector
}
//Returns true if the pin has moved enough to count as knocked down
func getPinMoved(vector: SCNVector3) -> Bool {
    let sum = pow(abs(vector.x),2) + pow(abs(vector.y),2) + pow(abs(vector.z),2)
    //print("SUM", sum)
    //0.109193966 is largest difference for a pin that hasn't moved, .125 is a good threshold
    if sum > 0.125 {
        return true
    }
    return false
}

//Returns true if the ball has "stopped"
func getVelocity(vector: SCNVector3) -> Bool {
    let sum = vector.x + vector.y + vector.z
    if sum < 0.4 {
        return true
    }
    return false
}

extension GameViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval){
        let ball = bowlingBall.presentation
        let ballPosition = ball.position
        
        let targetPosition = SCNVector3Make(ballPosition.x - 13 , (ballPosition.y + 5), ballPosition.z)
        
        var cameraPosition = cameraNode.position
        
        let camDamping:Float = 0.3

        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
        let yComponent = cameraPosition.y * (1 - camDamping) + targetPosition.y * camDamping
        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
    
        cameraPosition = SCNVector3Make(xComponent, yComponent, zComponent)
        cameraNode.position = cameraPosition
        
        //If ball stopped count how many pins were moved
        if getVelocity(vector: bowlingBall.physicsBody!.velocity) && ballStatus == true  {
            ballStatus = false
            //Find how many pins were displaced
            let seconds = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                let pinsKnocked = self.getMovedPins()
                if self.standingPins == [false,false,false,false,false,false,false,false,false,false] {
                    self.standingPins = [true,true,true,true,true,true,true,true,true,true]
                }
                //Reload the screen
                //self.currentPlayer = 0
                let player = self.players![self.currentPlayer % 2]
                player.updateFrame(score: Float(pinsKnocked))
                if player.frameIndex % 3 == 0 {
                    self.standingPins = [true,true,true,true,true,true,true,true,true,true]
                    self.currentPlayer += 1
                }
                self.ballStatus = true
                self.viewDidLoad()
                self.bowlingBall.physicsBody?.velocity = SCNVector3Make(1,0,0)
                self.ballStatus = false
            }
            
        }
    }
    
}
