//
//  Routines.swift
//  hiit IT
//
//  Created by Emily Widjaja on 9/9/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import Foundation

class Routines: NSObject, NSCoding {
    
    var routineName = ""
    var sets:Int?
    var exercises:Int? //exercises in each set
    var exerciseDuration:Int? //number of seconds
    var exerciseRestDuration:Int?
    var setRestDuration:Int?
    
    //MARK: - Save Methods
    //adding code to save data
    init(routineName: String, sets: Int, exercises: Int, exerciseDuration: Int, exerciseRestDuration: Int, setRestDuration: Int) {
        self.routineName = routineName
        self.sets = sets
        self.exercises = exercises
        self.exerciseDuration = exerciseDuration
        self.exerciseRestDuration = exerciseRestDuration
        self.setRestDuration = setRestDuration
    }
    
    //read from disk
    required init?(coder aDecoder: NSCoder) {
        routineName = aDecoder.decodeObject(forKey: "routineName") as? String ?? ""
        sets = aDecoder.decodeObject(forKey: "sets") as? Int ?? 0
        exercises = aDecoder.decodeObject(forKey: "exercises") as? Int ?? 0
        exerciseDuration = aDecoder.decodeObject(forKey: "exerciseDuration") as? Int ?? 0
        exerciseRestDuration = aDecoder.decodeObject(forKey: "exerciseRestDuration") as? Int ?? 0
        setRestDuration = aDecoder.decodeObject(forKey: "setRestDuration") as? Int ?? 0
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(routineName, forKey: "routineName")
        aCoder.encode(sets, forKey: "sets")
        aCoder.encode(exercises, forKey: "exercises")
        aCoder.encode(exerciseDuration, forKey: "exerciseDuration")
        aCoder.encode(exerciseRestDuration, forKey: "exerciseRestDuration")
        aCoder.encode(setRestDuration, forKey: "setRestDuration")
    }
    
    //MARK: - Builds set and routines
    //assumes a basic exercise, TODO: Allow for more complex variations
    //build a set - TODO: allow for exericise name inputs
    func buildSet() -> [String:Int] {
        var set = [String:Int]()
        
        for i in 1...exercises! {
            let exerciseName = "Exercise " + String(i)
            let restName = "Rest " + String(i)
            set[exerciseName] = exerciseDuration!
            
            if i != exercises! {
                set[restName] = exerciseRestDuration!
            }
        }
        
        return set
    }
        
    //build a routine
    func buildRoutine() -> [String:Int] {
        var routine = [String:Int]()
        
        for i in 1...sets! {
            let restName = "Rest after set " + String(i)
            let setGenerated = self.buildSet()
            routine.merge(dict: setGenerated)
            
            if i != sets! {
                routine[restName] = setRestDuration!
            }
        }
        
        return routine
    }
    


}
