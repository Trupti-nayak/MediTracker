//
//  HistoryViewModel.swift
//  MediTracker
//
//  Created by Trupti on 09/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import Foundation

struct MedicineHistoryViewModel {
    var morning:String?
    var noon:String?
    var night:String?
    var date:String?
    var score:Int16
    
    init(with medsHistory: MedsHistory) {
        self.date = medsHistory.date
        self.score = medsHistory.score
        self.morning = medsHistory.morning
        self.noon = medsHistory.afterNoon
        self.night = medsHistory.night
    }
}

struct HistoryViewModel {
    
    var historyModel: [MedicineHistoryViewModel]?{
        return fetchHistory()
    }
    
    private func fetchHistory()-> [MedicineHistoryViewModel]? {
        var medsHistroyList:[MedicineHistoryViewModel]? = [MedicineHistoryViewModel]()
        
        if let historyResult:[MedsHistory] = DBManager.shared.fetchHistory(){
            medsHistroyList = historyResult.map { return MedicineHistoryViewModel(with: $0) }
        }
        return medsHistroyList
    }
    
    func updateYesterdayData(){
        guard let yesterday = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: Date()) else { return }
        let isYesterday = Calendar.autoupdatingCurrent.isDateInYesterday(yesterday)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateWithTime:String = dateFormatter.string(from: yesterday)
        let dateArr = dateWithTime.components(separatedBy: " ")

        if isYesterday{
            let medsHistroy:MedsHistory? = DBManager.shared.fetchHistory(with: dateArr[0])
            if medsHistroy == nil{
                // update No meds taken and score 0 with date to db
                let date:String = dateArr[0]
                let score:Int16 = 0
                DBManager.shared.createRecordWith(date: date, score: score)
            }
            
        }
    }

}
