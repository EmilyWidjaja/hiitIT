//
//  TimerViewController.swift
//  hiit IT
//
//  Created by Emily Widjaja on 11/9/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    //The Workout Routine
    var workoutToLoad: Routines?
    var numberOfSets: Int?
    var numberOfExercises: Int?
    var exerciseDuration: Int?
    var restDuration: Int?
    var setRestDuration: Int?
    
    //Current place in Routine
    var currentSet = 1 {
        didSet {
            setLabel.text = "Set \(currentSet) of \(numberOfSets ?? 0)"
        }
    }
    var currentExercise = 1 {
        didSet {
            exerciseLabel.text = "Exercise \(currentExercise) of \(numberOfExercises ?? 0)"
        }
    }
    var timer: Timer?
    var segment = "Ex"
    
    //labels
    @IBOutlet weak var timeLeftLabel: UILabel!
    var timeLeft = 0 {
        didSet {
            timeLeftLabel.text = String(timeLeft)
        }
    }
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //loads data
        numberOfSets = workoutToLoad?.sets
        numberOfExercises = workoutToLoad?.exercises
        exerciseDuration = workoutToLoad?.exerciseDuration
        restDuration = workoutToLoad?.exerciseRestDuration
        setRestDuration = workoutToLoad?.setRestDuration
        
        currentExercise = 1
        currentSet = 1
        
        //start program
        setUpTimer(segment: segment) //default starts with exercise
    }
    
    //MARK: Timer Methods
    //starts timer
    func setUpTimer(segment: String) {
        print("Timer set up. for \(segment) segment.")
        switch segment {
        case "Ex":
            timeLeft = exerciseDuration!
        case "Rest":
            timeLeft = restDuration!
        case "Set Rest":
            timeLeft = setRestDuration!
        default:
            print("wrong keyword!")
        }
        print(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    //timer function to fire timer & decide next timer
    @objc func fireTimer() {
        timeLeft -= 1
        
        if timeLeft <= 2 {
            playSound(fileName: "lowBeep.mp3")
        }
        
        if timeLeft == 0 {//2nd exercise segment not activating
            timer?.invalidate()
            playSound(fileName: "highBeep.mp3")
            print("timer invalidated")
            
            //decides next step
            decideNextTimer()
        }
    }
    //MARK: - BUG
    //first beep throws [aqsrv] AQServer.cpp:68:APIResult: Exception caught in AudioQueueInternalNotifyRunning - error -66671
    var soundEffect: AVAudioPlayer!
    func playSound(fileName: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: nil) {
            let url = URL(fileURLWithPath: path)
            do {
                soundEffect = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                soundEffect?.play()
            } catch {
                print("file could not be loaded.")
            }
        } else {
            print("file not found.")
        }
    }
    
    func decideNextTimer() {
        switch segment {
        case "Ex":
            //add check for last exercise before starting timer
            if currentExercise == numberOfExercises {
                checkFinished()
            } else {
                segment = "Rest"
                exerciseLabel.text = "Rest"
                setUpTimer(segment: segment)
            }
        case "Rest":
            checkFinished()
        case "Set Rest":
            segment = "Ex"
            setUpTimer(segment: segment)
        default:
            print("Error! None of the cases are found.")
        }
    }
    
    func checkFinished() {
        if currentExercise >= numberOfExercises! {
            if currentSet >= numberOfSets! {
                //finished routine
                print("Routine finished")
                finish()
            } else { //routine not finished, start next set
                segment = "Set Rest"
                print("Set finished but routine not finished, next set")
                currentSet += 1
                currentExercise = 1
                setUpTimer(segment: segment)
            }
        } else {
            //set not finished, start next exercise
            currentExercise += 1
            print("start next exercise")
            segment = "Ex"
            setUpTimer(segment: segment)
        }
    }
    
    
    //MARK: Routine finished
    func finish() {
        let ac = UIAlertController(title: "Exercise Complete!", message: "Congratulations!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .cancel) { [weak self] action in
            self?.dismiss(animated: true) //goes back to summary view controller
        }
        ac.addAction(action)
        present(ac, animated: true)
    }

}

