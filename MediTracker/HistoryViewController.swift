//
//  HistoryViewController.swift
//  MediTracker
//
//  Created by Trupti on 06/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var emptyPlaceholderImgView: UIImageView!
    
    @IBOutlet weak var historyTableView: UITableView!{
        didSet{
            historyTableView.backgroundColor = .white
        }
    }
    
    var historyArr:[MedsHistory]?
    let historyViewModel:HistoryViewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Medicine History"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        historyViewModel.updateYesterdayData()
        if historyViewModel.historyModel?.count ?? 0 > 0 {
            historyTableView.isHidden = false
            emptyPlaceholderImgView.isHidden = true

        }else{
             historyTableView.isHidden = true
            emptyPlaceholderImgView.isHidden = false
        }
    }
    

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyViewModel.historyModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as? HistoryTableViewCell{
            if let medcineHistory = historyViewModel.historyModel?[indexPath.row] {
                cell.medicineHistoryViewModel = medcineHistory // dependency injection
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.2
    }
    
}
