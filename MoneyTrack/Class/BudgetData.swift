//
//  BudgetData.swift
//  MoneyTrack
//
//  Created by Default User on 4/14/24.
//
//Author: Aayushi Patel

import Foundation
import UIKit

// Class to represent budget data
class BudgetData: NSObject {
    
    // Properties to store budget information
    var id : Int?
    var blimit : String?
    var spend : String?
    var category : String?
    
    // Method to initialize BudgetData object with provided data
    func initWithData(theRow i:Int, theBlimit l:String, theSpend s:String, theCategory c:String)
    {
        id = i
        blimit = l
        spend = s
        category = c
    }
    
    
}

