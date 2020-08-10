//
//  MediTrackerTestsDemo.swift
//  MediTrackerTestsDemo
//
//  Created by Trupti on 10/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import XCTest
@testable import MediTracker

class MediTrackerTestsDemo: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMedicineHistoryViewModel(){
        let managedContext = DBManager.shared.persistentContainer.viewContext
        
        let medstaken = MedsHistory(context: managedContext)
        medstaken.date = "10/08/2020"
        medstaken.score = 30
        
        let today = Calendar.current.isDateInToday(Date())
        let yesterday = Calendar.current.isDateInYesterday(Date())
        let medicineHistory: MedicineHistoryViewModel = MedicineHistoryViewModel(with: medstaken)
        XCTAssertEqual(medicineHistory.date, medstaken.date)
       
    }

}
