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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat //"dd/MM/yyyy"
        
        let startDateString = getStartDate()

        guard let yesterday = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: Date()), let startDate = dateFormatter.date(from: startDateString as? String ?? "") else { return }
        let isYesterday = Calendar.autoupdatingCurrent.isDateInYesterday(yesterday)
        let dateWithTime:String = dateFormatter.string(from: yesterday)
        let dateArr = dateWithTime.components(separatedBy: " ")
        let diff = Calendar.current.dateComponents([.day], from: startDate, to: Date())
        if let day = diff.day, day > 1 || isYesterday
        {
            let medsHistroy:MedsHistory? = DBManager.shared.fetchHistory(with: dateArr[0])
            if medsHistroy == nil{
                let date:String = dateArr[0]
                let score:Int16 = 0
                DBManager.shared.createRecordWith(date: date, score: score)
            }
            
        }
    }

}
