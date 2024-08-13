//
//  BudgetViewController.swift
//  MoneyTrack
//
//  Created by Default User on 4/14/24.
//
// Author : Aayushi Patel

import UIKit
// Class for managing budget-related functionalities
class BudgetViewController: UIViewController, UITextFieldDelegate  {
    // Label to display budget information
    @IBOutlet var lbbview : UILabel!
    
    // Textfields for user input
    @IBOutlet var tbLimit : UITextField!
    @IBOutlet var tbSpend : UITextField!
    @IBOutlet var tbCategory : UITextField!
    
    // Action triggered when adding a budget entry
    @IBAction func addPerson(sender : Any)
    {
        // Initialize BudgetData object with user input
        let budget : BudgetData = BudgetData.init()
        budget.initWithData(theRow: 0, theBlimit: tbLimit.text!, theSpend: tbSpend.text!, theCategory: tbCategory.text!)
        
        // Access AppDelegate to interact with SQLite database
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Insert budget data into SQLite database
        let returnCode : Bool = mainDelegate.insertIntoDatabase(budget: budget)
        
        // Show alert indicating success or failure of the operation
        var returnMSG : String = "Budget Added"
        
        if returnCode == false
        {
            returnMSG = "Budget Add Failed"
        }
        
        let alertController = UIAlertController(title: "SQLite Add", message: returnMSG, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
       
        
    }
    
    
    // Action triggered when unwinding to HomeViewController
    @IBAction func unwindToHomeViewController(sender : UIStoryboardSegue)
    {
        
    }
    
    // Method to dismiss keyboard when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // Method to handle touch events and perform segue if touch occurs within label frame
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
   
        let touch : UITouch = touches.first!
   
        let touchPoint : CGPoint = touch.location(in: self.view!)
    
        let tableFrame : CGRect = lbbview.frame
  
        if tableFrame.contains(touchPoint)
        {
          
            performSegue(withIdentifier: "HomeSegueToTable", sender: self)
            
        }
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
