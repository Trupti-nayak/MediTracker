//
//  ViewController.swift
//  MediTracker
//
//  Created by Trupti on 06/08/20.
//  Copyright © 2020 Trupti. All rights reserved.
//

import UIKit

struct Constants{
    static let Morning = "Morning"
    static let AfterNoon =  "AfterNoon"
    static let Night = "Night"
    
    static let GreetMorning = "Good \(Morning)!"
    static let GreetAfternoon = "Good \(AfterNoon)!"
    static let GreetNight = "Good \(Night)!"
    static let DefaultGreeting = "Hello!"
    
    static let dateFormat = "dd/MM/yyyy HH:mm"
}

class TodayViewController: UIViewController {

    // MARK:- Variables
 //   let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    
    var date:String = ""
    var time:String = ""
    var greeting = ""
    let userDefaults = UserDefaults.standard
    var isLastEntry = false
    var todayViewModel = TodayViewModel()
    
    @IBOutlet weak var medsTakenButton: UIButton!{
        didSet{
            medsTakenButton.layer.cornerRadius = 10
            medsTakenButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.borderColor = #colorLiteral(red: 0.08119424433, green: 0.7279129624, blue: 0.745798111, alpha: 1)
            containerView.layer.borderWidth = 1
            containerView.layer.cornerRadius = 10
            containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK:- Viewcontroller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Filepath of coredata",FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let dateArr = todayViewModel.dateArr
        date = dateArr[0]
        time = dateArr[1]
        enableButton()
        setupSubViews()
        
      
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        scheduleNotification(notificationType: Constants.GreetMorning, time: 11)
        scheduleNotification(notificationType: Constants.GreetAfternoon, time: 14)
        scheduleNotification(notificationType: Constants.GreetNight, time: 20)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        greetingLabel.text = todayViewModel.greeting
    }
    // MARK: Local Notification scheduler
    func scheduleNotification(notificationType: String, time: Int) {
           
        let medsHistroy:MedsHistory? = todayViewModel.fetchHistory(with: date)
        let date = Date()
        var triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        guard let hour = triggerDate.hour else{return}
        
        if hour >= 11 && medsHistroy?.morning == nil  || hour >= 14 && medsHistroy?.afterNoon == nil || hour >= 20 && medsHistroy?.night == nil{
            let notiCenter = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            
            content.title = notificationType
            content.body = "Its time to take your medicines"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "alarm"
            content.badge = 1
            
            triggerDate.hour = time
            triggerDate.minute = 01
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

         //   let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: "Medicine Local Notification\(notificationType)", content: content, trigger: trigger)
            
            notiCenter.add(request)
        }
           
       }
    
    private func setupSubViews(){
        scoreLabel.font = scoreLabel.font.withSize(self.view.frame.width * 0.4)
        greetingLabel.text = todayViewModel.greeting
        setupLabelProperties()
    }
    
    private func setupLabelProperties(){
        if let medsHistory:MedsHistory = todayViewModel.fetchHistory(with: date) {
            scoreLabel.text = "\(medsHistory.score)"
            switch (medsHistory.score) {
            case 30:
                scoreLabel.textColor = .systemBlue
                
            case 60:
                scoreLabel.textColor = .yellow
                
            case 100:
            scoreLabel.textColor = .green
                
            default:
                scoreLabel.textColor = .red
            }
        }
    }
    
    private func enableButton(){
        medsTakenButton.isUserInteractionEnabled = true
        medsTakenButton.alpha = 1
    }
    
    private func disableButton(){
        medsTakenButton.isUserInteractionEnabled = false
        medsTakenButton.alpha = 0.5
    }
    
    // MARK:- Action methods

    @IBAction func medsTakenClicked(_ sender: Any) {
        todayViewModel.takeMedicines()
        setupLabelProperties()
        
//        scoreLabel.text = "\(todayViewModel.scoreAndColor.0)"
//        switch todayViewModel.scoreAndColor.1 {
//        case ScoreColor.Blue:
//            scoreLabel.textColor = .systemBlue
//        case ScoreColor.Yellow:
//            scoreLabel.textColor = .yellow
//        case ScoreColor.Green:
//            scoreLabel.textColor = .green
//        default:
//            scoreLabel.textColor = .red
//        }
    }
    
 
    private func showAlert(with message: String, title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "DONE", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showHistory(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "HistoryViewController") as? HistoryViewController {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

