//
//  addgarages.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 20/02/2022.
//

import Foundation
import Firebase
import Geofirestore
import GeoFire
import MapKit

class test: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let geoFirestoreRef = Firestore.firestore().collection("FeaturedGarages")
//        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
//
//        geoFirestore.setLocation(location: CLLocation(latitude: 51.52007, longitude: -2.6007), forDocumentWithID: "6qjvaNBtSeJySgQbgCOI") { (error) in
//            if let error = error {
//                print("An error occured: \(error)")
//            } else {
//                print("Saved location successfully!")
//            }
//        }
//
//                geoFirestore.setLocation(location: CLLocation(latitude: 51.50825, longitude: -0.15383), forDocumentWithID: "Zewxw6khufME6asLznFg") { (error) in
//            if let error = error {
//                print("An error occured: \(error)")
//            } else {
//                print("Saved location successfully!")
//            }
//                }
    
        
        
//        //MARK: BRISTOL GARAGES
//
//        //golden hill garage
//
//        addgarage(closing: "17:00", opening: "08:30", Lat: 51.48487, Long: -2.59804, Name: "Golden Hill Garage", Rating: 4.3, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/GoldenHillGarage.jpeg?alt=media&token=647690b6-bda5-454c-a803-3dafee1b9a92", prices: generaterandomprices(), times: generaterandomtimes())
//
//        //kwik fit whiteladies
//
//        addgarage(closing: "18:00", opening: "08:30", Lat: 51.46274, Long: -2.60851, Name: "Kwik Fit - Whiteladies Road", Rating: 4.7, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/kwikfitbristol.jpeg?alt=media&token=4b748e2d-e933-422e-afee-6f1ef26fbb65", prices:generaterandomprices(), times: generaterandomtimes())
//
//        //audi bristol
//
//        addgarage(closing: "18:00", opening: "08:00", Lat: 51.52478, Long: -2.60558, Name: "Bristol Audi", Rating: 4.6, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/GoldenHillGarage.jpeg?alt=media&token=647690b6-bda5-454c-a803-3dafee1b9a92", prices: generaterandomprices(), times: generaterandomtimes())
//
//        //mercedes bristol
//
//        addgarage(closing: "18:30", opening: "08:00", Lat: 51.52356, Long: -2.61176, Name: "Mercedes-Benz of Bristol", Rating: 4.4, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/mercedesbristol.jpeg?alt=media&token=3b4b5da7-5eb6-4719-926a-914086e6aac7", prices: generaterandomprices(), times: generaterandomtimes())
//
//        //bmw bristol
//
//        addgarage(closing: "18:00", opening: "08:00", Lat: 51.52130, Long: -2.61836, Name: "Dick Lovett BMW Bristol", Rating: 4.5, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/bmwbristol.jpeg?alt=media&token=b8156aa7-6437-4da5-9ef8-543071532f3d", prices: generaterandomprices(), times: generaterandomtimes())
//
//        //MARK: LONDON GARAGES
//
//        //mini park lane
//
//        addgarage(closing: "18:00", opening: "09:00", Lat: 51.50869, Long: -0.15418, Name: "Mini Park lane", Rating: 4.7, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/miniParkLane.jpeg?alt=media&token=e9667258-2583-4365-8de3-c90c868e7232", prices: generaterandomprices(), times: generaterandomtimes())
//
//        // bmw park lane
//
//        addgarage(closing: "18:00", opening: "09:00", Lat: 51.50825, Long: -0.15383, Name: "BMW Park Lane", Rating: 4.2, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/bmwparklane.jpeg?alt=media&token=ad1d820a-027e-4b59-966b-dbcd779a5904", prices: generaterandomprices(), times: generaterandomtimes())
//
//        // porsche mayfair
//
//        addgarage(closing: "18:00", opening: "08:30", Lat: 51.50648, Long: -0.14384, Name: "Porsche - Mayfair", Rating: 4.9, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/porsche-mayfair.jpeg?alt=media&token=4f635f6d-5407-4870-86c6-40b490f9d2f8", prices: generaterandomprices(), times: generaterandomtimes())
//
//        // Aston Martin Mayfair
//
//        addgarage(closing: "18:00", opening: "08:30", Lat: 51.51130, Long: -0.15704, Name: "Aston Martin - Mayfair", Rating: 4.4, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/aston%20martin%20mayfair.jpeg?alt=media&token=674e80a7-fc11-4725-80b4-7331e8f48b0b", prices: generaterandomprices(), times: generaterandomtimes())
//
//        // kwikfit london
//
//        addgarage(closing: "18:00", opening: "08:30", Lat: 51.49267, Long: -0.15796, Name: "Kwik Fit - Chelsea", Rating: 4.3, Image: "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/kwikfit%20chelsea.jpeg?alt=media&token=1bd500ff-bb59-440d-a6e0-d083578eba4a", prices: generaterandomprices(), times: generaterandomtimes())
//
//
    }
    
    func randomRange(range: Range<Int>, increment:Int ) -> Int {
        if Int(range.endIndex-1) % increment != 0  { return 0 }
        if increment > (Int(range.endIndex-1 ) - Int(range.startIndex )) { return 0 }
        if increment == 1 { return Int( arc4random_uniform( UInt32( Int(range.endIndex) - Int(range.startIndex) ) ) ) + Int(range.startIndex) }
        let numberOfRandomElements = ( ( Int(range.endIndex ) - Int(range.startIndex )) / increment ) + 1
        let randomAux = Int(arc4random_uniform(UInt32(numberOfRandomElements)))
        return  randomAux * increment + Int(range.startIndex)
    }
    
    
    func generaterandomprices() -> [Int] {
        var prices = [Int]()
        while prices.count < 10 {
            let randomInt = randomRange(range: 10..<101, increment: 5)
                prices.append(randomInt)
            
        }
        return prices
    }
    
    func generaterandomtimes() -> [Int] {
        var times = [Int]()
        while times.count < 10 {
            let randomInt = randomRange(range: 10..<151, increment: 5)
            times.append(randomInt)
            
        }
        return times
    }
    
    func addgarage(closing: String, opening: String, Lat: Double, Long:Double, Name:String, Rating:Double, Image:String, prices:[Int], times:[Int]) {
        let garageref = Firestore.firestore().collection("Garages").document()
        
        let data:[String:Any] = ["ClosingHour": closing,"OpeningHour": opening, "Latitude": Lat , "Longitude":Long ,"Name":Name,"Rating":Rating, "uid":garageref.documentID, "Image":Image]
        
        garageref.setData(data)
        
        let geoFirestoreRef = Firestore.firestore().collection("Garages")
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef)
        
        geoFirestore.setLocation(location: CLLocation(latitude: Lat, longitude: Long), forDocumentWithID: garageref.documentID) { (error) in
            if let error = error {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
                
                let names = ["Air-Con", "Battery", "Brakes", "Bulbs", "Engine","Exhaust","MOT", "Suspension","Tyres","Windscreen"]
                
                for index in 0...names.count - 1 {
                    let data: [String : Any] = ["Name": names[index], "Price":prices[index], "Time":times[index]]
                    print(data)
                    let serviceref = Firestore.firestore().collection("Garages").document(garageref.documentID).collection("Services")
                    serviceref.addDocument(data: data) { error in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    else {
                        print("uploaded")
                        }
                    }
                }
            }
        }
    }
}
