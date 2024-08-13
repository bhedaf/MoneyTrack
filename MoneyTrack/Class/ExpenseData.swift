//
//  ExpenseData.swift
//  MoneyTrack
//
//  Created by Default User on 4/15/24.
// Author : Freya Bheda

import UIKit

class ExpenseData: NSObject {

    var id : Int?
    var title : String?
    var amount : String?
    var date : String?
    var note : String?
    
    func initWithData(theRow i:Int, theTitle t:String, theAmount a:String, theDate d:String, theNote n:String)
    {
        id = i
        title = t
        amount = a
        date = d
        note = n
    }
    
}
