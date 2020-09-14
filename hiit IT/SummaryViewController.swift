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
    @IBOutlet weak var setsLabel: UITextField!
    @IBOutlet weak var exercisesLabel: UITextField!
    @IBOutlet weak var exerciseDurationLabel: UITextField!
    @IBOutlet weak var restDurationLabel: UITextField!
    @IBOutlet weak var setRestDurationLabel: UITextField!
    @IBOutlet weak var toggleButtonLabel: UIButton!
    @IBOutlet weak var startButtonLabel: UIButton!
    
    
    var workoutToLoad: Routines?    //refactor so selected workout uses workout To Load
    var mode = "summary"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads in summary mode
        loadSummaryMode()
        
        //to load edit screen straight from home screen
        /*if mode == "summary" {
            setsLabel.isUserInteractionEnabled = false
            exercisesLabel.isUserInteractionEnabled = false
            exerciseDurationLabel.isUserInteractionEnabled = false
            restDurationLabel.isUserInteractionEnabled = false
            setRestDurationLabel.isUserInteractionEnabled = false
        }*/
        
    
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
            //loadSummaryMode()
            checkValidInput()
            saveValidInput()
        }
    }
    
    func loadSummaryMode() {
        mode = "summary"
        modeswitch()
        
        if setsLabel.isUserInteractionEnabled != false {
            print("Error! modeswitch incorrect.") }
        workoutName.text = workoutToLoad?.routineName
        setsLabel.text = "\(workoutToLoad?.sets! ?? 0)"
        exercisesLabel.text = "\(workoutToLoad?.exercises! ?? 0)"
        exerciseDurationLabel.text = "\(workoutToLoad?.exerciseDuration! ?? 0)s"
        restDurationLabel.text =  "\(workoutToLoad?.exerciseRestDuration! ?? 0)s"
        setRestDurationLabel.text = "\(workoutToLoad?.setRestDuration! ?? 0)s"
        
        startButtonLabel.isHidden = false
        startButtonLabel.isUserInteractionEnabled = true
        toggleButtonLabel.setTitle("Edit", for: .normal)
    }
    
    func loadEditMode() {
        mode = "edit"

        //makes buttons interactive
        modeswitch()
        if setsLabel.isUserInteractionEnabled != true {
            print("Error! modeswitch incorrect.")
        }
        //slightly changes description
        exerciseDurationLabel.text = "\(workoutToLoad?.exerciseDuration! ?? 0)"
        restDurationLabel.text =  "\(workoutToLoad?.exerciseRestDuration! ?? 0)"
        setRestDurationLabel.text = "\(workoutToLoad?.setRestDuration! ?? 0)"

        startButtonLabel.isHidden = true
        startButtonLabel.isUserInteractionEnabled = false
        toggleButtonLabel.setTitle("Done", for: .normal)
    }
    
    //TODO: check valid input function
    func checkValidInput() {
        
    }
    
    func saveValidInput() {
        let sets = Int(setsLabel.text!)
        workoutToLoad?.sets = sets!
        workoutToLoad?.exercises = Int(exercisesLabel.text!)
        workoutToLoad?.exerciseDuration = Int(exerciseDurationLabel.text!)
        workoutToLoad?.setRestDuration = Int(setRestDurationLabel.text!)
        workoutToLoad?.exerciseRestDuration = Int(restDurationLabel.text!)
        
        print("\(workoutToLoad?.sets!)")
        print(workoutToLoad?.exercises!)
        print(workoutToLoad?.exerciseDuration!)
        
        print("Pi")
        print(workoutToLoad?.setRestDuration!)
        print(workoutToLoad?.exerciseRestDuration!)
        dismiss(animated: true) /*({ [weak self] in
            if let vc = self?.storyboard?.instantiateViewController(identifier: "Home") as? ViewController {
                //add saveworkout method
                vc.newWorkout = self?.workoutToLoad!
                vc.newWorkoutAdded()
            }
         }*/
        let homeViewController = ViewController()
        homeViewController.newWorkout = workoutToLoad
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    
    func modeswitch() {
        setsLabel.isUserInteractionEnabled = !setsLabel.isUserInteractionEnabled
        exercisesLabel.isUserInteractionEnabled = !exercisesLabel.isUserInteractionEnabled
        exerciseDurationLabel.isUserInteractionEnabled = !exerciseDurationLabel.isUserInteractionEnabled
        restDurationLabel.isUserInteractionEnabled = !restDurationLabel.isUserInteractionEnabled
        setRestDurationLabel.isUserInteractionEnabled = !setRestDurationLabel.isUserInteractionEnabled
    }
}

