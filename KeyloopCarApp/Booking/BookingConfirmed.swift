//
//  BookingConfirmed.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 06/11/2021.
//

import UIKit
import Firebase

class BookingConfirmed: UIViewController {
    
    let lightgrey = UIColor(hexString: "#F6F6F6")
    let numberplatecolour = UIColor(hexString: "#F9D349")
    let blackbrown = UIColor(hexString: "#1D2128")
    var bookingID:String?
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var bookingConfirmedText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 24, text: "Booking Confirmed", bold: true)
        return text
    }()
    
    lazy var checkImage: UIButton = {
        let button = UIButton()
        button.setsizedImage(symbol: "checkmark.circle", size: 16, colour: .black)
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var CarImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "bookingconfirmedcar.jpg")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var bookingDetailsText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 24, text: "Booking Details", bold: true)
        return text
    }()
    
    lazy var container: UIView = {
       let view = UIView()
        view.backgroundColor = lightgrey
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var NumberPlateText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 25, text: "FP63 YVF", bold: true)
        text.backgroundColor = numberplatecolour
        text.textAlignment = .center
        text.layer.cornerRadius = 8
        text.layer.masksToBounds = true
        return text
    }()
    
    lazy var line1: UIView = {
        let view = UIView()
        view.backgroundColor = lightgrey
        return view
    }()
    
    lazy var paymentSummaryText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 24, text: "Payment Summary", bold: true)
        return text
    }()
    
    lazy var ServiceButton = ConfirmedButton.setimage(image: "wrench")
    lazy var DateButton = ConfirmedButton.setimage(image: "calendar")
    lazy var TimeButton = ConfirmedButton.setimage(image: "clock")
    lazy var GarageButton = ConfirmedButton.setimage(image: "fuelpump.fill")
    lazy var CarButton = ConfirmedButton.setimage(image: "car")
    
    lazy var ServiceLabel = ConfirmedLabel.text(textlabel: "Service Type")
    lazy var DateLabel = ConfirmedLabel.text(textlabel: "Date")
    lazy var TimeLabel = ConfirmedLabel.text(textlabel: "Time")
    lazy var GarageLabel = ConfirmedLabel.text(textlabel: "Garage")
    lazy var CarLabel = ConfirmedLabel.text(textlabel: "Car")
    
    lazy var ImageStackView = equalStackView.layoutButtons(buttons: [ServiceButton,DateButton,TimeButton,GarageButton,CarButton])
    
    lazy var LabelStackView = equalStackView.layoutLabels(labels: [ServiceLabel,DateLabel,TimeLabel,GarageLabel,CarLabel])
    
    lazy var Servicetext = ConfirmedText.text(textlabel: "MOT")
    lazy var DateText = ConfirmedText.text(textlabel: "1 February 2022")
    lazy var TimeText = ConfirmedText.text(textlabel: "11:00 AM")
    lazy var GarageText = ConfirmedText.text(textlabel: "Dick Lovett Mini Bristol")
    
    lazy var PaymentButton = ConfirmedButton.setimage(image: "sterlingsign.circle")
    lazy var Paymentlabel = ConfirmedText.text(textlabel: "Subtotal:")
    lazy var Paymenttext = ConfirmedText.text(textlabel: "£90")
    
    lazy var line2: UIView = {
        let view = UIView()
        view.backgroundColor = lightgrey
        return view
    }()
    
    lazy var DoneButton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .white, backgroundColour: blackbrown, size: 18, text: "Done", image: nil, cornerRadius: 10)
        return button
    }()
    
    lazy var successTitle = SuccessText.text(textlabel: "Success!", size: 18)
    lazy var successText = ConfirmedLabel.bookingtext(textlabel: "Your Service has been successfully booked.",size: 10)
    lazy var BookingID = SuccessText.text(textlabel: "Booking ID:", size: 12)
    lazy var BookingIDText = SuccessText.text(textlabel: "#7JDJ7KS", size: 12)
    lazy var BookedOn = SuccessText.text(textlabel: "Booked On:", size: 12)
    lazy var BookedOnText = SuccessText.text(textlabel: "7/11/2021", size: 12)
    
    lazy var BookingTitleStackView = equalStackView.layoutBookingLabels(labels: [BookingID,BookedOn])
    lazy var BookingTextStackView = equalStackView.layoutBookingLabels(labels: [BookingIDText,BookedOnText])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        DoneButton.addTarget(self, action: #selector(dismisstohome), for: .touchUpInside)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.isNavigationBarHidden = true
        getBooking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.isNavigationBarHidden = false
    }
    
    func getBooking() {
        guard let bookingID = bookingID else {return}

        let ref = Firestore.firestore().collection("userbookings").document(bookingID)
        ref.getDocument { document, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = document?.data() else {return}
            let bookingdata = bookingdocumentclass(dictionary: data)
            self.NumberPlateText.text = bookingdata.car
            self.BookingIDText.text = self.bookingID
            self.BookedOnText.text = self.getTodaysDate()
            self.Servicetext.text = bookingdata.service
            self.DateText.text = bookingdata.date
            self.TimeText.text = bookingdata.startTime
            self.GarageText.text = bookingdata.garage
            self.NumberPlateText.text = bookingdata.car
            guard let price = bookingdata.price else {return}
            self.Paymenttext.text = "\(price)"
        }

    }

    
    @objc func dismisstohome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(bookingConfirmedText)
        scrollView.addSubview(checkImage)
        scrollView.addSubview(CarImage)
        scrollView.addSubview(bookingDetailsText)
        scrollView.addSubview(container)
        
        container.addSubview(successTitle)
        container.addSubview(successText)
        container.addSubview(BookingTitleStackView)
        container.addSubview(BookingTextStackView)

        scrollView.addSubview(ImageStackView)
        scrollView.addSubview(LabelStackView)
        
        scrollView.addSubview(Servicetext)
        scrollView.addSubview(DateText)
        scrollView.addSubview(TimeText)
        scrollView.addSubview(GarageText)
        scrollView.addSubview(NumberPlateText)
        
        scrollView.addSubview(line1)
        
        scrollView.addSubview(paymentSummaryText)
        scrollView.addSubview(PaymentButton)
        scrollView.addSubview(Paymentlabel)
        scrollView.addSubview(Paymenttext)
        
        scrollView.addSubview(line2)
        scrollView.addSubview(DoneButton)
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        bookingConfirmedText.anchor(top: scrollView.topAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        
        checkImage.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: bookingConfirmedText.rightAnchor, paddingLeft: 5, right: nil, paddingRight: 0, width: 30, height: 30)
        checkImage.centerYAnchor.constraint(equalTo: bookingConfirmedText.centerYAnchor).isActive = true
        
        container.anchor(top: bookingConfirmedText.bottomAnchor, paddingTop: 15, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 30, right: scrollView.rightAnchor, paddingRight: 30, width: 0, height: 0)
        container.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.125).isActive = true
        //container.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true

        successTitle.anchor(top: container.topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: container.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 30, width: 0, height: 0)
        
        successText.anchor(top: successTitle.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: container.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 30, width: 0, height: 0)
        
        BookingTitleStackView.anchor(top: successText.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: container.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        
        BookingTextStackView.anchor(top: successText.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: BookingTitleStackView.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
     
        CarImage.anchor(top: container.bottomAnchor, paddingTop: -20, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
            self.CarImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.28).isActive = true
        self.CarImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        
        bookingDetailsText.anchor(top: CarImage.bottomAnchor, paddingTop: -5, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        
        ImageStackView.anchor(top: bookingDetailsText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        ImageStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.425).isActive = true
        ImageStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true

        LabelStackView.anchor(top: bookingDetailsText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: ImageStackView.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        LabelStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.425).isActive = true
        //LabelStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.).isActive = true

        Servicetext.anchor(top: LabelStackView.arrangedSubviews.first?.bottomAnchor, paddingTop: -10, bottom: nil, paddingBottom: 0, left: LabelStackView.arrangedSubviews.first?.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        DateText.anchor(top: LabelStackView.arrangedSubviews[1].bottomAnchor, paddingTop: -10, bottom: nil, paddingBottom: 0, left: LabelStackView.arrangedSubviews.first?.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        TimeText.anchor(top: LabelStackView.arrangedSubviews[2].bottomAnchor, paddingTop: -10, bottom: nil, paddingBottom: 0, left: LabelStackView.arrangedSubviews.first?.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        GarageText.anchor(top: LabelStackView.arrangedSubviews[3].bottomAnchor, paddingTop: -10, bottom: nil, paddingBottom: 0, left: LabelStackView.arrangedSubviews.first?.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        
        NumberPlateText.anchor(top: LabelStackView.arrangedSubviews[4].bottomAnchor, paddingTop: -10, bottom: nil, paddingBottom: 0, left: LabelStackView.arrangedSubviews.first?.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 150, height: 40)
        
        line1.anchor(top: NumberPlateText.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 0, right: scrollView.rightAnchor, paddingRight: 0, width: 0, height: 10)
        line1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        
        paymentSummaryText.anchor(top: line1.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)

        PaymentButton.anchor(top: paymentSummaryText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        
        Paymentlabel.anchor(top: nil, paddingTop: 20, bottom: nil, paddingBottom: 0, left: PaymentButton.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        Paymentlabel.centerYAnchor.constraint(equalTo: PaymentButton.centerYAnchor).isActive = true
        
        Paymenttext.anchor(top: nil, paddingTop: 20, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: scrollView.rightAnchor, paddingRight: 15, width: 0, height: 0)
        Paymenttext.centerYAnchor.constraint(equalTo: PaymentButton.centerYAnchor).isActive = true
        
        line2.anchor(top: PaymentButton.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 0, right: scrollView.rightAnchor, paddingRight: 0, width: 0, height: 5)
        line2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        
        DoneButton.anchor(top: line2.bottomAnchor, paddingTop: 20, bottom: scrollView.bottomAnchor, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 60)
        DoneButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        DoneButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.6).isActive = true
    }

}

class bookingdocumentclass: NSObject {

    
    var car: String?
    var service:String?
    var price:Int?
    var startTime:String?
    var endTime:String?
    var date:String?
    var notes:String?
    var garage: String?
    var checkedIn: Bool?
    var id: String?
    var name: String?
    
    var checkInTime: String?
    var recieved: Bool?
    var stage1: Bool?
    var stage2: Bool?
    var completed: Bool?
    var customeruid: String?
    
    var AdvisoryNoticeItems: [String]?

    
    
    init(dictionary: [String:Any]) {
        super.init()
        
        car = dictionary["car"] as? String
        service = dictionary["service"] as? String
        price = dictionary["price"] as? Int
        startTime = dictionary["startTime"] as? String
        endTime = dictionary["endTime"] as? String
        date = dictionary["date"] as? String
        notes = dictionary["notes"] as? String
        garage = dictionary["garage"] as? String
        checkedIn = dictionary["checkedIn"] as? Bool
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        
        checkInTime = dictionary["checkInTime"] as? String
        checkedIn = dictionary["checkedIn"] as? Bool
        recieved = dictionary["recieved"] as? Bool
        stage1 = dictionary["stage1"] as? Bool
        stage2 = dictionary["stage2"] as? Bool
        completed = dictionary["completed"] as? Bool
        customeruid = dictionary["customeruid"] as? String
        AdvisoryNoticeItems = dictionary["AdvisoryNoticeItems"] as? [String]
    }
}

