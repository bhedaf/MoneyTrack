//
//  ViewBudgetViewController.swift
//  MoneyTrack
//
//  Created by Default User on 4/14/24.
// Author: Aayushi Patel

import UIKit
// Class for viewing budget data in a table view
class ViewBudgetViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    // Access AppDelegate to interact with SQLite database
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Read budget data from the SQLite database
        mainDelegate.readDataFromDatabase()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Method to determine number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.budget.count
    }
    
    // Method to set height for each row in the table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Method to populate table view cells with budget data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell  = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style: .default, reuseIdentifier: "cell")
        
        
        let rowNum = indexPath.row
        tableCell.primaryLabel.text = mainDelegate.budget[rowNum].category
        tableCell.secondaryLabel.text = mainDelegate.budget[rowNum].blimit
        
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
    }
    
    // Method to handle selection of a row in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNum = indexPath.row
        let alertController = UIAlertController(title: mainDelegate.budget[rowNum].category, message: mainDelegate.budget[rowNum].spend, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        

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
