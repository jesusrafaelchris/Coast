//
//  TrackService.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 06/11/2021.
//

import UIKit
import ISTimeline
import FittedSheets
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol showMessageDelegate: AnyObject {
    func showMessageLog(garageid: String, garagename: String)
//func givevalues(bookingId:String,garage:String,service:String,finishtime:String)

}


class TrackService: UIViewController, showMessageDelegate {
    
    func showMessageLog(garageid: String, garagename: String) {
        let messagelog = MessageLog(collectionViewLayout: UICollectionViewFlowLayout())
        print("tappedfromtracking")
        messagelog.garageid = garageid
        messagelog.garagename = garagename
        let navView = UINavigationController(rootViewController: messagelog)
        navigationController?.present(navView, animated: true, completion: nil)
    }
    
    
    lazy var TrackStatusTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 28, text: "Track Status", bold: true)
        return text
    }()
    
    lazy var dash1 = trackDashView.empty()
    lazy var dash2 = trackDashView.empty()
    lazy var dash3 = trackDashView.empty()
    lazy var dash4 = trackDashView.empty()
    lazy var dash5 = trackDashView.empty()
    
    var bookingId: String?
    var garage: String?
    var service: String?
    var finish: String?
    var garageuid: String?
    var completed = false
    
    lazy var dashstackview = equalStackView.layoutTrackDashes(views: [dash1,dash2,dash3,dash4,dash5])
    
    
    lazy var CarImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "carfixing.jpg")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let width = 130

    
    lazy var timeline: ISTimeline = {
        let timeline = ISTimeline(frame: CGRect(x: 0, y: 0, width: width, height: 350))
        timeline.backgroundColor = .white
        timeline.bubbleColor = .clear
        timeline.descriptionColor = .darkText
        timeline.titleColor = .black
        timeline.pointDiameter = 14
        timeline.lineWidth = 2
        timeline.bubbleArrows = false
        return timeline
    }()
    
    lazy var checkedIn = ConfirmedLabel.bookingtext(textlabel: "", size: 16)
    lazy var recieved = ConfirmedLabel.bookingtext(textlabel: "", size: 16)
    lazy var stage1 = ConfirmedLabel.bookingtext(textlabel: "Stage 1 Check", size: 16)
    lazy var stage2 = ConfirmedLabel.bookingtext(textlabel: "Stage 2 Check", size: 16)
    lazy var finished = ConfirmedLabel.bookingtext(textlabel: "Vehicle ready to pick up", size: 16)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTrackingData()
    }
    
    func openSheet() {
        let controller = PullUpView()
        controller.finish = self.finish
        controller.garage = self.garage
        controller.garageuid = self.garageuid
        controller.delegate = self
        controller.completed = self.completed

        let options = SheetOptions(
            useInlineMode: true
        )

        let sheetController = SheetViewController(controller: controller, sizes: [.percent(0.12), .fixed(250)], options: options)
        sheetController.allowGestureThroughOverlay = true
        sheetController.dismissOnPull = false
        sheetController.allowPullingPastMaxHeight = false
        sheetController.allowPullingPastMinHeight = false
        sheetController.overlayColor = .clear
        sheetController.dismissOnOverlayTap = true

        // animate in
        sheetController.animateIn(to: view, in: self)
    }

    
    func setupView() {
        view.addSubview(TrackStatusTitle)
        view.addSubview(dashstackview)
        view.addSubview(CarImage)
        view.addSubview(timeline)

        
        TrackStatusTitle.anchor(top: view.topAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        dashstackview.anchor(top: TrackStatusTitle.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 40, right: view.rightAnchor, paddingRight: 40, width: 0, height: 0)
        
        CarImage.anchor(top: dashstackview.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
            self.CarImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        self.CarImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        
        
        timeline.anchor(top: CarImage.bottomAnchor, paddingTop: -10, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 40, right: nil, paddingRight: 20, width: CGFloat(width), height: 350)
   
    }
    
    func addlabels() {
        
        view.addSubview(checkedIn)
        view.addSubview(recieved)
        view.addSubview(stage1)
        view.addSubview(stage2)
        view.addSubview(finished)
        
        checkedIn.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 20, left: timeline.subviews[0].rightAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        checkedIn.centerYAnchor.constraint(equalTo: timeline.subviews[0].centerYAnchor).isActive = true
        
        
        recieved.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 20, left: timeline.subviews[2].rightAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 10, width: 0, height: 0)
        recieved.centerYAnchor.constraint(equalTo: timeline.subviews[2].centerYAnchor).isActive = true
        recieved.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
        stage1.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 20, left: timeline.subviews[4].rightAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        stage1.centerYAnchor.constraint(equalTo: timeline.subviews[4].centerYAnchor).isActive = true
        //codee = vibe
        // freya wuz here
        stage2.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 20, left: timeline.subviews[6].rightAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        stage2.centerYAnchor.constraint(equalTo: timeline.subviews[6].centerYAnchor).isActive = true
        
        finished.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 20, left: timeline.subviews[8].rightAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 10, width: 0, height: 0)
        finished.centerYAnchor.constraint(equalTo: timeline.subviews[8].centerYAnchor).isActive = true
        finished.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
    }


}


struct timelinepoints {
    
    var title: String
    var spacing: String
    var isCompleted: Bool
    
    init(title: String, spacing: String, isCompleted: Bool) {
        self.title = title
        self.spacing = spacing
        self.isCompleted = isCompleted
    }
}

//MARK: GET TRACKING DATA
extension TrackService {
    
    func showReview(service: String, garage: String, garageImage:String) {
        let review = reviewViewController()
        review.service = service
        review.garage = garage
        review.garageimage = garageImage
        review.id = self.bookingId
        
        let nav = UINavigationController(rootViewController: review)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {

            sheet.detents = [ .medium()]

        }
        present(nav, animated: true, completion: nil)
    }
    
    
    func getTrackingData() {
        var points = [timelinepoints]()
        guard let id = bookingId else {return}
        let trackingref = Firestore.firestore().collection("userbookings").document(id)

       // trackingref.getDocument(completion: { snapshot, error in
        
        trackingref.addSnapshotListener({ snapshot, error in

            if error != nil {
                print(error!.localizedDescription)
            }
            let data = snapshot?.data()
            self.timeline.points.removeAll()
            
            let checkintime = data?["checkInTime"] as? String ?? "          "
            let checkincompleted = data?["checkedIn"] as! Bool
            
            let recievedtime = data?["recievedTime"] as? String ?? "           "
            let recievedcompleted = data?["recieved"] as! Bool
            
            let stage1time = data?["stage1Time"] as? String ?? "           "
            let stage1completed = data?["stage1"] as! Bool
            
            let stage2time = data?["stage2Time"] as? String ?? "           "
            let stage2completed = data?["stage2"] as! Bool
            
            let completedtime = data?["completedTime"] as? String ?? "           "
            let completedbool = data?["completed"] as! Bool
            
            let stage1error = data?["stage1error"] as? Bool ?? false
            let stage2error = data?["stage2error"] as? Bool ?? false
            
            let reviewed = data?["reviewed"] as? Bool ?? false
            
            let service = data?["service"] as? String ?? ""
            let garage = data?["garage"] as? String ?? ""
            let garageimage = data?["garageImage"] as? String ?? ""
            
            let advisory1 = data?["stage1advisory"] as? String ?? ""
            let advisory2 = data?["stage2advisory"] as? String ?? ""
            
            let endTime = data?["endTime"] as? String ?? ""
            self.finish = endTime
            
            if completedbool {
                self.completed = true
                self.finish = completedtime
                
                if reviewed == false {
                    //show review pop up
                    self.showReview(service: service, garage: garage,garageImage: garageimage)
                }
            }
            

            let checkin = timelinepoints(title: checkintime, spacing: "", isCompleted: checkincompleted)
            let recieved = timelinepoints(title: recievedtime, spacing: "\n\n", isCompleted: recievedcompleted)
            let stage1 = timelinepoints(title: stage1time, spacing: "", isCompleted: stage1completed)
            let stage2 = timelinepoints(title: stage2time, spacing: "\n\n", isCompleted: stage2completed)
            let completed = timelinepoints(title: completedtime, spacing: "", isCompleted: completedbool)
        
            self.garageuid = data?["garageuid"] as? String
            points.removeAll()
            points.append(checkin)
            points.append(recieved)
            points.append(stage1)
            points.append(stage2)
            points.append(completed)
            
            self.configurepoints(points:points)
            
            guard let name = Auth.auth().currentUser?.displayName else {return}
            
            switch checkincompleted {
            case true:
                self.checkedIn.text = "\(name) checked in"
                self.checkedIn.textColor = .black
                self.dash1.backgroundColor = .black

            case false:
                self.checkedIn.text = "Waiting for \(name) to check in"

            }
            
            switch recievedcompleted {
            case true:
                guard let garage = self.garage else {return}
                self.recieved.text = "\(garage) recieved your car"
                self.recieved.textColor = .black
                self.dash2.backgroundColor = .black

            case false:
                guard let garage = self.garage else {return}
                self.recieved.text = "Waiting for \(garage) to recieve your car"

            }
            
            switch stage1completed {
            case true:
                self.stage1.text = "Stage 1 Checks Complete"
                self.stage1.textColor = .black
                self.dash3.backgroundColor = .black
                if stage1error {
                    self.stage1.text = "Stage 1 Checks Complete ⚠️"
                    let upsell = ConfirmUpsell()
                    upsell.id = self.bookingId
                    upsell.endTime = endTime
                    upsell.fault = advisory1
                    let price = 60
                    upsell.price = price
                    upsell.services.removeAll()
                    let service = GarageServiceData(dictionary: ["Name":"Tyres", "Price": price,"Time":30])
                    upsell.services.append(service)
                    self.sheetpresent(view: upsell)
                }

            case false:
                self.stage1.text = "Waiting for Stage 1 Checks"

            }
            
            switch stage2completed {
            case true:
                self.stage2.text = "Stage 2 Checks Complete"
                self.stage2.textColor = .black
                self.dash4.backgroundColor = .black
                if stage2error {
                    self.stage2.text = "Stage 2 Checks Complete ⚠️"
                    let upsell = ConfirmUpsell()
                    upsell.id = self.bookingId
                    upsell.endTime = endTime
                    upsell.fault = advisory2
                    let price = 45
                    upsell.price = price
                    upsell.services.removeAll()
                    let service = GarageServiceData(dictionary: ["Name":"Brakes", "Price": price,"Time":40])
                    upsell.services.append(service)
                    self.sheetpresent(view: upsell)
                }

            case false:
                self.stage2.text = "Waiting for Stage 2 Checks"

            }
            
            switch completedbool {
            case true:
                guard let service = self.service else {return}
                self.finished.text = "\(service) complete, your car is ready to pick up"
                self.finished.textColor = .black
                self.dash5.backgroundColor = .black

            case false:
                guard let service = self.service else {return}
                self.finished.text = "We'll let you know when your \(service) is complete"

            }

           
            self.addlabels()
            self.openSheet()
            self.view.layoutIfNeeded()
        })
    }
    
    func sheetpresent(view:UIViewController) {
        
        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {

            sheet.detents = [ .medium()]

        }
        present(nav, animated: true, completion: nil)
        }
    
    func configurepoints(points: [timelinepoints]) {
        self.timeline.points.removeAll()
        for Point in points {
            let point = ISPoint(title: Point.title)
            point.description = Point.spacing
            
            if Point.isCompleted == false {
                point.lineColor = .lightGray
                //timeline.titleColor = .lightGray
                point.pointColor = point.lineColor
                point.fill = false
                
            }
            else {
                point.fill = true
                point.lineColor = .black
                point.pointColor = point.lineColor
            }
            
            point.touchUpInside =
                { (point:ISPoint) in
                    print(point.title)
            }
            self.timeline.points.append(point)
        }
    }
}
