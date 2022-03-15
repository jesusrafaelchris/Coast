//
//  ShowBookings.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 08/11/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import BetterSegmentedControl
import Nuke

class ShowBookings: UIViewController {
    
    let blackbrown = UIColor(hexString: "#1D2128")
    
    var pastbookings = [bookingdocumentclass]()
    var bookings = [bookingdocumentclass]()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var MyBookings: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 28, text: "My Bookings", bold: true)
        return text
    }()
    
    lazy var backgroundImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.layer.masksToBounds = true
        imageview.image = UIImage(named: "emptybookings")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var BookingCollectionView: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(BookingCell.self, forCellWithReuseIdentifier: "bookingcell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.layer.cornerRadius = 20
        collectionview.layer.masksToBounds = true
        collectionview.isUserInteractionEnabled = true
        //collectionview.isScrollEnabled = false
        return collectionview
    }()

    lazy var PastBookingCollectionView: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(BookingCell.self, forCellWithReuseIdentifier: "pastbookingcell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.layer.cornerRadius = 20
        collectionview.layer.masksToBounds = true
        //collectionview.isScrollEnabled = false
        return collectionview
    }()

    lazy var segmentcontrol = BetterSegmentedControl(
        frame: CGRect(x: 0, y: 0, width: 200.0, height: 30.0),
        segments: LabelSegment.segments(withTitles: ["Scheduled", "Complete"],
                                        normalTextColor: .black,
                                        selectedTextColor: .white),
        options:[.backgroundColor(.white),
                 .indicatorViewBackgroundColor(UIColor(hexString: "222222")),
                 .cornerRadius(10.0),
                 .animationSpringDamping(1.0)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "F5F5F8")
        setupView()
        checkforBookings()
        segmentcontrol.addTarget(self,action: #selector(segmentchanged(_:)),for: .valueChanged)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func segmentchanged(_ sender: BetterSegmentedControl) {
        
    }
    
    func checkforBookings() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("users").document(uid).collection("Bookings")
        ref.addSnapshotListener { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let documents = snapshot?.documents else {return}
            self.bookings.removeAll()
            for document in documents {
                let data = document.data()
                let bookingdata = bookingdocumentclass(dictionary: data)
                self.bookings.append(bookingdata)
                }
            DispatchQueue.main.async {
                self.BookingCollectionView.reloadData()
                }
            }
        }
    
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(MyBookings)
        scrollView.addSubview(segmentcontrol)
        scrollView.addSubview(BookingCollectionView)
        scrollView.addSubview(backgroundImage)
        //view.addSubview(PastBookingCollectionView)
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        MyBookings.anchor(top: scrollView.topAnchor, paddingTop: 50, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        segmentcontrol.anchor(top: MyBookings.bottomAnchor, paddingTop: 15, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        BookingCollectionView.anchor(top: segmentcontrol.bottomAnchor, paddingTop: 15, bottom: scrollView.bottomAnchor, paddingBottom: 10, left: view.leftAnchor, paddingLeft: 15, right: view.rightAnchor, paddingRight: 15, width: 0, height: 0)

        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.8).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.8).isActive = true
        
    }
    

}

extension ShowBookings:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.BookingCollectionView {
            if bookings.count == 0 {
                backgroundImage.isHidden = false
                return 0
            }
            else {
                backgroundImage.isHidden = true
                return bookings.count
            }
        }
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //booking view test logic
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookingcell", for: indexPath) as! BookingCell
        let booking = bookings[indexPath.item]

        //checkin button logic
            
            if getTodaysDateforbooking() == booking.date && booking.checkedIn == false {
                print("today is booking day and not checked in")
                cell.checkinbutton.isHidden = false
                cell.trackbutton.isHidden = true
            }
            
            if booking.checkedIn == true {
                print("checked in and ready to track")
                cell.checkinbutton.isHidden = true
                cell.trackbutton.isHidden = false
                
                if booking.completed == true {
                    cell.trackbutton.setTitle("Review", for: .normal)
                }
                else {
                    cell.trackbutton.setTitle("Track", for: .normal)
                }
            }
            
        //
            
        cell.GarageName.text = booking.garage
        cell.ServiceName.text = booking.service
            if let date = booking.date{
                cell.Datebutton.setTitle("  \(date)", for: .normal)
            }
            
            if let time = booking.startTime {
                cell.Timebutton.setTitle("  \(time)", for: .normal)
            }

            if let price = booking.price {
                cell.Pricebutton.setTitle("  \(price)", for: .normal)
            }
        
        let urlstring = "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/Mini_%20Main.png?alt=media&token=7dd7a5d2-d545-4519-80cb-211a64611123"
            if let url = URL(string: urlstring) {
                Nuke.loadImage(with: url, into: cell.ServiceImage)
            }
       // cell.NumberPlateText.text = booking.car
        
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = view.bounds.height / 5
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        return itemSize // Replace with count of your data for collectionViewA
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let booking = bookings[indexPath.item]
        print("selected")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if let id = booking.id {
        
        if booking.checkedIn == false && getTodaysDateforbooking() == booking.date {
            let currentTime = getcurrentTime()
            
            let data: [String:Any] = ["checkInTime":currentTime, "checkedIn":true,"recieved":false,"stage1":false,"stage2":false,"completed":false]
            
            let ref = Firestore.firestore().collection("userbookings").document(id)
            let userbookingsref = Firestore.firestore().collection("users").document(uid).collection("Bookings").document(id)
                
            ref.setData(data, merge: true)
            userbookingsref.setData(data, merge: true)
            
        }
        
        else if booking.checkedIn == true {
            guard let garage = booking.garage else {return}
            guard let service = booking.service else {return}
            guard let finish = booking.endTime else {return}
            
            let track = TrackService()
            track.bookingId = id
            track.garage = garage
            track.service = service
            track.finish = finish
            let navView = UINavigationController(rootViewController: track)
            navigationController?.present(navView, animated: true, completion: nil)
            }
        }
    }
}
