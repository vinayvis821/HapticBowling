//
//  Scoring.swift
//  hapticBowling
//
//  Created by Anton Young on 11/17/22.


// SCORING
//Spare: 10 points + the number of pins you knock down for your first attempt at the next frame.
//
//Strike: score 10 points + the number of pins you knock down for the entire next frame.
//
//Double:
//1st frame – 20 points + the number of pins you knock down in 3rd frame
//2nd frame – same as scoring for strike
//
//Turkey:
//1st frame - 30 points
//2nd frame – same as scoring for double
//3rd frame – same as scoring for strike
//
//Four-Bagger:
//1st frame - 30 points
//2nd frame - 30 points
//
//3rd frame – same as scoring for double
//4th frame – same as scoring for strike
import SceneKit
class Scoring {
    //Each player's inputed name
    var playerName: String
    var consecutiveStrikes: Int
    var previousSpare: Bool
    //var consecutiveStrikes: Int
    // Score multiplier after a strike/spare
    
    //Stores 3 scores for each frame, for displaying purposes
    var frames: [SCNVector3]
    
    var frameIndex: Int
    var currentFrame: Int
    var scorePerFrame: [Float]
    var totalScore: Float
    //Param should be playername
    init(playerName: String) {
        self.playerName = playerName
        self.frames = [SCNVector3](repeating: SCNVector3Make(0, 0, 0), count: 10)
        self.scorePerFrame = [Float](repeating: 0, count: 10)
        self.totalScore = 0
        self.frameIndex = 0
        self.currentFrame = 0
        self.consecutiveStrikes = 0
        self.previousSpare = false
    }
    
    //Given a score, what do you do?
    func updateFrame(score: Float) {
        
        if currentFrame >= 10 {
            print("Game finished")
            return
        }
        if frameIndex % 3 == 0 {
            frames[currentFrame].x = score
            scorePerFrame[currentFrame] += score
            if previousSpare {
                scorePerFrame[currentFrame - 1] += score
            }
        } else if frameIndex % 3 == 1 {
            
            frames[currentFrame].y = score
            scorePerFrame[currentFrame] += score
            checkStrikes()
            
            if scorePerFrame[currentFrame] == 10 {
                previousSpare = true
                print("Nice spare!")
            } else {
                previousSpare = false
            }
            if currentFrame != 9 {
                //.z should be skipped if it isn't the 10th frame
                frameIndex += 1
                currentFrame += 1
            }
        } else if frameIndex % 3 == 2 { //Fix later so only if 10 pins were knocked down
                frames[currentFrame].z = score
                print("End game")
        }
        totalScore = calculateScore()
        if score == 10 && frameIndex % 3 == 0 {
            checkStrikes()
            frameIndex = 0
            consecutiveStrikes += 1
            print("Nice strike!")
            currentFrame += 1
        } else {
            frameIndex += 1
            consecutiveStrikes = 0
        }
        printStuff()
    }
    
    func printStuff() {
        print(playerName)
        //print(frames)
        print("Score: ", totalScore)
        //print(frameIndex)
        print("Consecutive Strikes", consecutiveStrikes)
        print("Frame: ", currentFrame)
        print("==================")
    }
    
    func checkStrikes() {
        if consecutiveStrikes > 0 {
            scorePerFrame[currentFrame - 1] += scorePerFrame[currentFrame]
            for i in 1..<consecutiveStrikes {
                if scorePerFrame[currentFrame - i] != 30 {
                scorePerFrame[currentFrame - i] += 10
                }
            }
            totalScore = calculateScore()
        }
    }
    func calculateScore() -> Float {
        var sum:Float = 0
        for i in 0..<scorePerFrame.count {
            sum += scorePerFrame[i]
        }
        return sum
    }
    
    
}
