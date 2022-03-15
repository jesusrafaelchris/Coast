//
//  Structs.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 01/02/2022.
//

import Foundation

class FirebaseCarData: NSObject {
    
    @objc var CO2Emissions:String?
    @objc var Colour: String?
    @objc var Year: String?
    @objc var Fuel: String?
    @objc var Make: String?
    @objc var Model: String?
    @objc var Registration: String?
    @objc var MotDate: String?
    @objc var MotDateString: String?
    var ValidMot: Bool?
    @objc var imageurl: String?
    
    
    
    init(dictionary: [String:Any]) {
        super.init()
        
        CO2Emissions = dictionary["CO2Emissions"] as? String
        Colour = dictionary["Colour"] as? String
        Year = dictionary["Year"] as? String
        Fuel = dictionary["Fuel"] as? String
        Make = dictionary["Make"] as? String
        Model = dictionary["Model"] as? String
        Registration = dictionary["Registration"] as? String
        MotDate = dictionary["MotDate"] as? String
        MotDateString = dictionary["MotDateString"] as? String
        ValidMot = dictionary["ValidMot"] as? Bool
        imageurl = dictionary["imageurl"] as? String

   
    }
}

class CarGarageData: NSObject {
    
    @objc var Make: String?
    @objc var Model: String?
    @objc var Registration: String?
    @objc var imageurl: String?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        Make = dictionary["Make"] as? String
        Model = dictionary["Model"] as? String
        Registration = dictionary["Registration"] as? String
        imageurl = dictionary["imageurl"] as? String

   
    }
}

class MOTData: NSObject {
    
    @objc var TestDate: String?
    @objc var OdometerUnit: String?
    var Odometer: Int?
    var DangerousCount: Int?
    var MajorCount: Int?
    var MinorCount: Int?
    @objc var AdvisoryNoticeItems: [String]?
    @objc var ReasonsForFailure: [String]?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        TestDate = dictionary["TestDate"] as? String
        OdometerUnit = dictionary["OdometerUnit"] as? String
        Odometer = dictionary["Odometer"] as? Int
        DangerousCount = dictionary["Registration"] as? Int
        MajorCount = dictionary["imageurl"] as? Int
        MinorCount = dictionary["TestDate"] as? Int
        AdvisoryNoticeItems = dictionary["Model"] as? [String]
        ReasonsForFailure = dictionary["Registration"] as? [String]

   
    }
}
