//
//  AppDelegate.swift
//  MoneyTrack
//
//  Created by Default User on 3/20/24.
//Author: Aayushi Patel, Freya Bheda.
//please also find the 2 methods add at the end of this file for notification system (external technology implemented by Freya Bheda)

import UIKit
import SQLite3
import NotificationCenter


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var expenseswindow: UIWindow?
    var expensesdatabaseName : String? = "Expenses.db"
    var expensesdatabasePath : String?
    var expenses : [ExpenseData] = []
    
    var window: UIWindow?
    var databaseName : String? = "Budgets.db"
    var databasePath : String?
    var budget : [BudgetData] = []
    // Method called when the application finishes launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        // Override point for customization after application launch.
                
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted{
                print("Notification access denied")
            }
        }
        
        let expensesdocumentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let expensesdocumentsDir = expensesdocumentPaths[0]
        expensesdatabasePath = expensesdocumentsDir.appending("/" + expensesdatabaseName!)
        expenses_checkAndCreateDatabase()
        expenses_readDataFromDatabase()
        
        
        // Find the document directory path
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDir = documentPaths[0]
        // Append filename to get the complete path of the database
        databasePath = documentsDir.appending("/" + databaseName!)
       
        // Check if the database exists, if not, create it
        checkAndCreateDatabase()
        // Read data from the database
        readDataFromDatabase()
        
        return true
    }
    
    
    func expenses_checkAndCreateDatabase()
    {
        var success = false
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: expensesdatabasePath!)
        if success        {return}
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + expensesdatabaseName!)
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: expensesdatabasePath!)
    
        return;
    }
    
    
    func expenses_readDataFromDatabase()
    {
        expenses.removeAll()
        
        var db: OpaquePointer? = nil
            
        if sqlite3_open(self.expensesdatabasePath, &db) == SQLITE_OK
        {
            print("Successfully opened connection to expenses database at \(self.expensesdatabasePath)")
                
            var queryStatement: OpaquePointer? = nil
            var queryStatementString : String = "select * from entries"
                
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                    
            while( sqlite3_step(queryStatement) == SQLITE_ROW )
            {
                let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                let ctitle = sqlite3_column_text(queryStatement, 1)
                let camount = sqlite3_column_text(queryStatement, 2)
                let cdate = sqlite3_column_text(queryStatement, 3)
                let cnote = sqlite3_column_text(queryStatement, 4)
                        
                let title = String(cString: ctitle!)
                let amount = String(cString: camount!)
                let date = String(cString: cdate!)
                let note = String(cString: cnote!)
               
                let data : ExpenseData = ExpenseData.init()
                data.initWithData(theRow: id, theTitle: title, theAmount: amount, theDate: date, theNote: note)
                expenses.append(data)
                        
                print("Query Result:")
                print("\(id) | \(title) | \(amount) | \(date) | \(note)")
                        
            }
                sqlite3_finalize(queryStatement)
                
        }
        else
            {
                print("SELECT statement could not be prepared for expenses")
            }
            sqlite3_close(db);

        }
        else
            {
                print("Unable to open database for expenses.")
            }
        }

    func expenses_insertIntoDatabase(expenses : ExpenseData) -> Bool
    {
        var db: OpaquePointer? = nil
        var returnCode : Bool = true
        
        if sqlite3_open(self.expensesdatabasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.expensesdatabasePath)")
            
            var insertStatement: OpaquePointer? = nil
            var insertStatementString : String = "insert into entries values(NULL, ?, ?, ?, ?)"
            
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
                let titleStr = expenses.title! as NSString
                let amountStr = expenses.amount! as NSString
                let dateStr = expenses.date! as NSString
                let noteStr = expenses.note! as NSString
                
                sqlite3_bind_text(insertStatement, 1, titleStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, amountStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, dateStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, noteStr.utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted expenses row. \(rowID)")
                } else {
                    print("Could not insert expenses row.")
                    returnCode = false
                }
                sqlite3_finalize(insertStatement)
            } else {
                print("INSERT statement for expenses could not be prepared.")
                returnCode = false
            }
            sqlite3_close(db);
            
        } else {
            print("Unable to open database.")
            returnCode = false
        }
        return returnCode
    }
    
    // Method to check if the database exists, and create it if it doesn't
    func checkAndCreateDatabase()
    {

  
        var success = false
        let fileManager = FileManager.default
        // Check if the database file exists
        success = fileManager.fileExists(atPath: databasePath!)
        // If the database file exists, return
        if success
        {
            return
        }
    
        // If the database file doesn't exist, copy it from the app bundle to the documents directory
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
    
    return;
    }
    // Method to read data from the database
    func readDataFromDatabase()
    {
        // Clear the existing budget data
    budget.removeAll()
    
        var db: OpaquePointer? = nil
        
        // Open connection to the database
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.databasePath)")
            
         
            var queryStatement: OpaquePointer? = nil
            var queryStatementString : String = "select * from entries"
            
            // Prepare SQL statement to retrieve data from the database
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                // Execute the query and iterate over the results
                while( sqlite3_step(queryStatement) == SQLITE_ROW ) {
                
                    
                    let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let blimit = sqlite3_column_text(queryStatement, 1)
                    let bspend = sqlite3_column_text(queryStatement, 2)
                    let bcategory = sqlite3_column_text(queryStatement, 3)
                    
                    let limit = String(cString: blimit!)
                    let spend = String(cString: bspend!)
                    let category = String(cString: bcategory!)
           
                    // Create BudgetData object and add it to the budget array
                    let data : BudgetData = BudgetData.init()
                    data.initWithData(theRow: id, theBlimit: limit, theSpend: spend, theCategory: category)
                    budget.append(data)
                    
                    print("Query Result:")
                    print("\(id) | \(limit) | \(spend) | \(category)")
                    
                }
                // Finalize the query statement
                sqlite3_finalize(queryStatement)
            } else {
                print("SELECT statement could not be prepared")
            }
            // Close the database connection
            sqlite3_close(db);

        } else {
            print("Unable to open database.")
        }
    
    }
    // Method to insert data into the database
    func insertIntoDatabase(budget : BudgetData) -> Bool
    {
     
        var db: OpaquePointer? = nil
        var returnCode : Bool = true
        
        // Open connection to the database
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(self.databasePath)")
            
            // Prepare SQL statement to insert data into the database
            var insertStatement: OpaquePointer? = nil
            var insertStatementString : String = "insert into entries values(NULL, ?, ?, ?)"
            
            // Prepare the statement
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
               
           
                // Bind data to the prepared statement
                let limitStr = budget.blimit! as NSString
                let spendStr = budget.spend! as NSString
                let categoryStr = budget.category! as NSString
                
                sqlite3_bind_text(insertStatement, 1, limitStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, spendStr.utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, categoryStr.utf8String, -1, nil)
                
                // Execute the statement
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted row. \(rowID)")
                } else {
                    print("Could not insert row.")
                    returnCode = false
                }
                // Finalize the statement
                sqlite3_finalize(insertStatement)
            } else {
                print("INSERT statement could not be prepared.")
                returnCode = false
            }
            
            
            // Close the database connection
            sqlite3_close(db);
            
        } else {
            print("Unable to open database.")
            returnCode = false
        }
        return returnCode
    }


    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
  
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
     
    }

    //delegate method invoked when notification is going to be presented to user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    //delegate method invoked when user interacts with notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

