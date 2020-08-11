//
//  TodayViewModel.swift
//  MediTracker
//
//  Created by Trupti on 09/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import Foundation
import CoreData

class TodayViewModel {
    let managedContext = DBManager.shared.persistentContainer.viewContext
    
    var greeting:String = ""
    
    var dateArr:[String] {
        return getCurrentDateAndTime()
    }
    
  //  var scoreAndColor:(Int16,ScoreColor) = (0,ScoreColor.Red)
    
    init() {
        greetingLogic()
    }
    
    private func greetingLogic() {
         let date = Date()
         let calendar = NSCalendar.current
         let currentHour = calendar.component(.hour, from: date as Date)
         let hourInt = Int(currentHour.description)!

         if hourInt >= 12 && hourInt <= 18 {
             greeting = Constants.GreetAfternoon
         }
         else if hourInt >= 5 && hourInt <= 12 {
             greeting = Constants.GreetMorning
         }
         else if hourInt >= 19 && hourInt <= 24 {
             greeting = Constants.GreetNight
         }
         else  {
             greeting = Constants.DefaultGreeting
         }
     }
    
    private func getCurrentDateAndTime() -> [String]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat//"dd/MM/yyyy HH:mm"
        let dateWithTime:String = dateFormatter.string(from: Date())
        let dateArr = dateWithTime.components(separatedBy: " ")
        UserDefaults.standard.set(dateWithTime, forKey: "StartDate") //StartDate
        return dateArr
    }
    
    func saveMedsHistory(){
        DBManager.shared.saveContext()
    }
    
    func fetchHistory(with date:String)-> MedsHistory?{
        DBManager.shared.fetchHistory(with: date)
    }
    
    func takeMedicines(){
        
        if greeting.contains(Constants.Morning){
            let medsHistory:MedsHistory? = fetchHistory(with: dateArr[0])
            if medsHistory?.morning == nil {
                createMedsRecord(date: dateArr[0], score: 30, time: dateArr[1])
            }
            
        }else if greeting.contains(Constants.AfterNoon) {
            
            if let medsHistory:MedsHistory = fetchHistory(with: dateArr[0]){
                
                if medsHistory.afterNoon == nil {
                    let totalscore = medsHistory.score + 30
                    medsHistory.setValue(dateArr[1], forKey: "afterNoon")
                    medsHistory.setValue(totalscore, forKey: "score")
                    saveMedsHistory()
                 //   updateScoreLabel(with: totalscore)
                }
                
            }else{
                createMedsRecord(date: dateArr[0], score: 30, time: dateArr[1])
            }
            
        }else if greeting.contains(Constants.Night){
            if let medsHistory:MedsHistory = fetchHistory(with: dateArr[0]){
                
                if medsHistory.night == nil {
                    let totalscore = medsHistory.score + 40
                    medsHistory.setValue(dateArr[1], forKey: "night")
                    medsHistory.setValue(totalscore, forKey: "score")
                    saveMedsHistory()
                   
                  //  updateScoreLabel(with: totalscore)
                }
                
            }else{
                createMedsRecord(date: dateArr[0], score: 40, time: dateArr[1])
            }

        }
        
    }
    
    private func createMedsRecord(date:String, score:Int16, time:String){
          let medstaken = MedsHistory(context: managedContext)
          medstaken.date = date
          medstaken.score = score // add score
          if greeting.contains(Constants.Morning){
              medstaken.morning = time
          }else if greeting.contains(Constants.AfterNoon){
              medstaken.afterNoon = time
          }else{
              medstaken.night = time
          }
          saveMedsHistory()
    //      updateScoreLabel(with: score)

      }
    
//    private func updateScoreLabel(with score:Int16){
//        if let medsHistory:MedsHistory = fetchHistory(with: dateArr[0]){
//            switch medsHistory.score {
//            case 30:
//                scoreAndColor = (medsHistory.score, ScoreColor.Blue)
//            case 60:
//                scoreAndColor = (medsHistory.score, ScoreColor.Yellow)
//            case 100:
//                scoreAndColor = (medsHistory.score, ScoreColor.Green)
//            default:
//                scoreAndColor = (medsHistory.score, ScoreColor.Red)
//            }
//        }
//    }
}

//enum ScoreColor{
//    case Red
//    case Yellow
//    case Blue
//    case Green
//}
