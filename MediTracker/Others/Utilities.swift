//
//  Utilities.swift
//  MediTracker
//
//  Created by Trupti on 10/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import Foundation


func getCurrentDateAndTime() -> [String]{
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = Constants.dateFormat//"dd/MM/yyyy HH:mm"
       let dateWithTime:String = dateFormatter.string(from: Date())
       let dateArr = dateWithTime.components(separatedBy: " ")
       return dateArr
}

func setStartDate(){
    let dateArr = getCurrentDateAndTime()
    UserDefaults.standard.set("\(dateArr[0]) \(dateArr[1])", forKey: "StartDate")
}

func getStartDate()-> Any?{
    return UserDefaults.standard.object(forKey: "StartDate")
}
