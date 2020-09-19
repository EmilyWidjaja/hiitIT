//
//  RoutinesModel.swift
//  hiit IT
//
//  Created by Emily Widjaja on 9/9/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//  Generates data for cells

import Foundation

class RoutinesModel {
    var routines = [Routines]()
    
    func templateWorkout() -> Routines {
        let templateWorkout = Routines(routineName: "Abs HIIT", sets: 2, exercises: 2, exerciseDuration: 5, exerciseRestDuration: 3, setRestDuration: 4)
        return templateWorkout
    }
    
   
}
