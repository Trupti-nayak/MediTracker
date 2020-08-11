//
//  HistoryTableViewCell.swift
//  MediTracker
//
//  Created by Trupti on 06/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var containerCell: UIView!{
        didSet{
            containerCell.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.8235294118, blue: 0.7921568627, alpha: 1)
            containerCell.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
            contentView.layer.shadowRadius = 1
            contentView.layer.shadowColor = UIColor.red.cgColor
        }
    }
    
    @IBOutlet weak var morningLabel: UILabel!{
        didSet{
            morningLabel.textColor = .white
        }
    }
    @IBOutlet weak var noonLabel: UILabel!{
        didSet{
            noonLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var nightLabel: UILabel!{
        didSet{
            nightLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            dateLabel.textColor = .white
        }
    }
    @IBOutlet weak var scoreLabel: UILabel!{
        didSet{
            scoreLabel.textColor = .yellow
        }
    }
    
    var medicineHistoryViewModel: MedicineHistoryViewModel!{
        didSet{
            setupCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCellData(){
        
        self.dateLabel.text = medicineHistoryViewModel.date
        
        if let morning = medicineHistoryViewModel.morning{
            self.morningLabel.isHidden = false
            self.morningLabel.text = "Morning: \(morning)"
        }else{
            self.morningLabel.isHidden = true
        }
        
        
        if let noon = medicineHistoryViewModel.noon{
            self.noonLabel.isHidden = false
            self.noonLabel.text = "After Noon: \(noon)"
            self.noonLabel.textColor = .white
        }else{
            self.noonLabel.isHidden = true
        }
        
        if let night = medicineHistoryViewModel.night{
            self.nightLabel.isHidden = false
            self.nightLabel.text = "Night: \(night)"
        }else{
            self.nightLabel.isHidden = true
        }
        
        if medicineHistoryViewModel.morning == nil && medicineHistoryViewModel.noon == nil && medicineHistoryViewModel.night == nil {
            self.noonLabel.isHidden = false
            self.noonLabel.text = "No Meds Taken"
            self.noonLabel.textColor = .red
        }

        self.scoreLabel.text = "\(medicineHistoryViewModel.score)"
    }

}
