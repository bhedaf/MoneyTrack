//
//  ExpensesViewController.swift
//  MoneyTrack
//
//  Created by Default User on 4/15/24.
// Author : Freya Bheda (notification system as external technology has been implemented)

import UIKit

class ExpensesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var lblTable : UILabel!
    
    @IBOutlet var tbTitle : UITextField!
    @IBOutlet var tbAmount : UITextField!
    @IBOutlet var tbNote : UITextField!
    
    
    @IBOutlet var dtdateTime : UIDatePicker!
    @IBOutlet var lbdateTime : UILabel!
    
    @IBAction func unwindToHomeViewController(sender : UIStoryboardSegue)
       {
       }
    
    //function to implement internal notification system for expense adding
    func setInternalMockNotification(){
        
        let center = UNUserNotificationCenter.current()
        
        //creating notification content
        let content = UNMutableNotificationContent()
        content.title = "Expense Added"
        content.body = "Expense have been added"
        
        //adding default notification sound
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
        
        //defining notification trigger time
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(3))
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats:   false)
        
        //creating notification system
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        
        center.add(request){
            (error) in
            if error != nil{
                //error handling
                print("Error = \(error?.localizedDescription ?? "error in location notification")")
            }
        }
    }
    
    @IBAction func addExpense(sender : Any)
    {
        let expense : ExpenseData = ExpenseData.init()
        expense.initWithData(theRow: 0, theTitle: tbTitle.text!, theAmount: tbAmount.text!, theDate: lbdateTime.text!, theNote: tbNote.text! )
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let returnCode : Bool = mainDelegate.expenses_insertIntoDatabase(expenses: expense)
        
        //calling the method so that everytime expense is add user is notified.
        setInternalMockNotification()
        
        
    }
    
    //date and time
    func updateLabel_dateTime(){
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d/yy h:mma"
            
            let selectedDateTime = dtdateTime.date
            let formattedDateTime = dateFormatter.string(from: selectedDateTime)
            
            lbdateTime.text = formattedDateTime
    }
    
    @IBAction func dateandtimeValueChanged (sender: UIDatePicker){
        updateLabel_dateTime()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabel_dateTime()
        // Do any additional setup after loading the view.
    }
    
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch : UITouch = touches.first!
        let touchPoint : CGPoint = touch.location(in: self.view!)
     
        let tableFrame : CGRect = lblTable.frame
     
        if tableFrame.contains(touchPoint)
        {
            performSegue(withIdentifier: "HomeSegueToTable", sender: self)
        }
    }
    
    
    
}
