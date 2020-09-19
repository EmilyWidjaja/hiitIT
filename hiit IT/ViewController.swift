//
//  ViewController.swift
//  hiit IT
//
//  Created by Emily Widjaja on 2/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//  Home screen (look up project 26 - see if that can be integrated)

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, tableDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let routineModel = RoutinesModel()
    var workoutArray = [Routines]()
    var newWorkout: Routines?
    var mode = "add"
    var lastTapped: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100.0
        
        //generates/retrieves workouts that should be in there. TODO: Add memory function
        //using NSCODING: workoutArray = routineModel.loadData()

        //load method
        let defaults = UserDefaults.standard

        if let savedRoutines = defaults.object(forKey: "routines") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                workoutArray = try jsonDecoder.decode([Routines].self, from: savedRoutines)
            } catch {
                print("Failed to load routines")
            }
        }
        
        
        
        let templateWorkout = routineModel.templateWorkout()
        workoutArray.append(templateWorkout)
    }
    
    //MARK: - SAVE Methods
    //using Codable
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(workoutArray) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "routines")
            print("Routine saved!")
        } else {
            print("Failed to save routines.")
        }
    }
    
    //MARK: -Create new Workout Method
    //when + button is tapped
    @IBAction func addNewWorkout(_ sender: Any) {
        mode = "add"
        if let controller = storyboard?.instantiateViewController(identifier: "Summary") as? SummaryViewController {
            let workoutToLoad = routineModel.templateWorkout() //loads template to be filled in?
            controller.mode = "edit"
            controller.workoutToLoad = workoutToLoad
            controller.delegate = self
            present(controller, animated: true)
        }
        
    }
    
    
    //MARK: -Information passed back from edit screen methods
    
    func workoutEdited(newWorkout: Routines) {
        //let wrongRoutine = Routines(routineName: "wrong", sets: 1, exercises: 1, exerciseDuration: 1, exerciseRestDuration: 1, setRestDuration: 1)
        
        if mode == "edit" {
            workoutArray[lastTapped!] = newWorkout
            print(workoutArray)
            tableView.reloadData()
        }
        if mode == "add" {
            print(workoutArray.count)
            workoutArray.append(newWorkout)
            print(workoutArray.count)
            tableView.reloadData()
        }
        save()
        dismiss(animated: true)
    }
    
    
    //MARK: -Table methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Routine", for: indexPath)
        cell.textLabel?.text = workoutArray[indexPath.row].routineName
        cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        return cell
    }
    
    //loads summaryVC when tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "Summary") as? SummaryViewController {
            
            let routineToLoad = workoutArray[indexPath.row]
            lastTapped = indexPath.row
            
            controller.workoutToLoad = routineToLoad
            controller.mode = "summary"
            controller.delegate = self //TODO: refactor this code so only declared as delegate once
            mode = "edit"   //can potentially edit
            //TODO: Implement for multiple sets and different hiit types
            present(controller, animated: true)
        }
    }

    

}

protocol tableDelegate {
    func workoutEdited(newWorkout: Routines)
}

