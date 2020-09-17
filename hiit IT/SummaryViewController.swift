//
//  SummaryViewController.swift
//  hiit IT
//
//  Created by Emily Widjaja on 2/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet var workoutName: UILabel!
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var setsLabel: UITextField!
    @IBOutlet weak var exercisesLabel: UITextField!
    @IBOutlet weak var exerciseDurationLabel: UITextField!
    @IBOutlet weak var restDurationLabel: UITextField!
    @IBOutlet weak var setRestDurationLabel: UITextField!
    @IBOutlet weak var toggleButtonLabel: UIButton!
    @IBOutlet weak var startButtonLabel: UIButton!
    
    
    var workoutToLoad: Routines?    //refactor so selected workout uses workout To Load
    var mode = "summary"
    var workoutToSend: Routines?
    var delegate: tableDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == "summary" {
            loadSummaryMode()
        } else if mode == "edit" {
            loadEditMode()
        } else {
            let message = "Something's gone wrong!"
            let ac = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Done", style: .cancel))
            present(ac, animated: true)
        }
        
        
    
    }
    

    //MARK: Timer screen starts
    @IBAction func startButton(_ sender: UIButton) {
        //insert code to instantiate next screen, dismiss both previous screens and start timer
        if let timervc = storyboard?.instantiateViewController(identifier: "Timer") as? TimerViewController {
            timervc.workoutToLoad = workoutToLoad
            timervc.modalPresentationStyle = .fullScreen
            timervc.modalTransitionStyle = .crossDissolve
            present(timervc, animated: true)
        } else {
            print("error! Timer VC not instantiated.")
            return
        }
        
    }
    
    //MARK: Edit/Summary mode
    @IBAction func toggleButton(_ sender: Any) {
        //if in summary mode switch to edit
        if mode == "summary" {
            loadEditMode()
            return
        }
        //if in edit mode switch to summary & save new routine (dismiss screen)
        if mode == "edit" {
            checkValidInput()
            saveEditedInput()
        }
    }
    
    func loadSummaryMode() {
        mode = "summary"
        
        if setsLabel.isUserInteractionEnabled != false {
            modeswitch()
        }
        workoutName.text = workoutToLoad?.routineName
        setsLabel.text = "\(workoutToLoad?.sets! ?? 0)"
        exercisesLabel.text = "\(workoutToLoad?.exercises! ?? 0)"
        exerciseDurationLabel.text = "\(workoutToLoad?.exerciseDuration! ?? 0)s"
        restDurationLabel.text =  "\(workoutToLoad?.exerciseRestDuration! ?? 0)s"
        setRestDurationLabel.text = "\(workoutToLoad?.setRestDuration! ?? 0)s"
        
        
        workoutNameTextField.isHidden = true
        workoutNameTextField.isUserInteractionEnabled = false
        workoutName.isHidden = false
        startButtonLabel.isHidden = false
        startButtonLabel.isUserInteractionEnabled = true
        toggleButtonLabel.setTitle("Edit", for: .normal)
    }
    
    func loadEditMode() {
        mode = "edit"

        //makes buttons interactive
        if setsLabel.isUserInteractionEnabled != true {
            modeswitch()
        }
        //slightly changes description
        setsLabel.text = "\(workoutToLoad?.sets! ?? 0)"
        exercisesLabel.text = "\(workoutToLoad?.exercises! ?? 0)"
        exerciseDurationLabel.text = "\(workoutToLoad?.exerciseDuration! ?? 0)"
        restDurationLabel.text =  "\(workoutToLoad?.exerciseRestDuration! ?? 0)"
        setRestDurationLabel.text = "\(workoutToLoad?.setRestDuration! ?? 0)"

        startButtonLabel.isHidden = true
        startButtonLabel.isUserInteractionEnabled = false
        workoutName.isHidden = true
        workoutNameTextField.isHidden = false
        workoutNameTextField.placeholder = "Routine Name"
        workoutNameTextField.isUserInteractionEnabled = true
        toggleButtonLabel.setTitle("Done", for: .normal)
    }
    
    //TODO: check valid input function
    func checkValidInput() {
        
    }
    
    
    func saveEditedInput() {
        let sets = Int(setsLabel.text!)
        workoutToLoad?.routineName = workoutNameTextField.text ?? "Workout" //sets default routine name in case one has not been specified
        workoutToLoad?.sets = sets!
        workoutToLoad?.exercises = Int(exercisesLabel.text!)
        workoutToLoad?.exerciseDuration = Int(exerciseDurationLabel.text!)
        workoutToLoad?.setRestDuration = Int(setRestDurationLabel.text!)
        workoutToLoad?.exerciseRestDuration = Int(restDurationLabel.text!)
        delegate?.workoutEdited(newWorkout: workoutToLoad!)
    }
    
    
    func modeswitch() {
        setsLabel.isUserInteractionEnabled = !setsLabel.isUserInteractionEnabled
        exercisesLabel.isUserInteractionEnabled = !exercisesLabel.isUserInteractionEnabled
        exerciseDurationLabel.isUserInteractionEnabled = !exerciseDurationLabel.isUserInteractionEnabled
        restDurationLabel.isUserInteractionEnabled = !restDurationLabel.isUserInteractionEnabled
        setRestDurationLabel.isUserInteractionEnabled = !setRestDurationLabel.isUserInteractionEnabled
    }
}

