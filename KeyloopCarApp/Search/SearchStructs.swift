//
//  SearchStructs.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 03/02/2022.
//

import Foundation

class GarageInfoData: NSObject {
    
    @objc var ClosingHour: String?
    @objc var OpeningHour: String?
    var Latitude: Double?
    var Longitude: Double?
    @objc var Name: String?
    @objc var Image: String?
    var Rating: Double?
    var uid: String?
    
    
    init(dictionary: [String:Any]) {
        super.init()
        
        ClosingHour = dictionary["ClosingHour"] as? String
        OpeningHour = dictionary["OpeningHour"] as? String
        Latitude = dictionary["Latitude"] as? Double
        Longitude = dictionary["Longitude"] as? Double
        Name = dictionary["Name"] as? String
        Image = dictionary["Image"] as? String
        Rating = dictionary["Rating"] as? Double
        uid = dictionary["uid"] as? String
        
    }
}

class GarageServiceData: NSObject {
    
    var Name: String?
    var Price: Int?
    var Time: Int?
    
    
    init(dictionary: [String:Any]) {
        super.init()
        
        Name = dictionary["Name"] as? String
        Price = dictionary["Price"] as? Int
        Time = dictionary["Time"] as? Int
    }
}

