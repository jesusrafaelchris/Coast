//
//  Structs.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 31/01/2022.
//

import Foundation
import UIKit

struct CarInfo: Decodable {

     var Success: Bool?
     var VehicleDetails:VehicleDetails?
     var VehicleMotData: [VehicleMotData]?
     var CalculatedMot: CalculatedMot?


}

struct VehicleDetails:Decodable {

    var CO2Emissions: String?
    var Colour: String?
    var Year: String?
    var Fuel: String?
    var Make: String?
    var Model: String?
    var Registration: String?

}

struct VehicleMotData:Decodable {

    var TestDate: String?
    var OdometerUnit: String?
    var Odometer: Int?
    var AdvisoryNoticeItems: [String]?
    var DangerousCount: Int?
    var MajorCount: Int?
    var MinorCount: Int?
    var ReasonsForFailure: [String]?

}

struct CalculatedMot:Decodable {

    var MotDate: String?
    var MotDateString: String?
    var ValidMot: Bool?

}
