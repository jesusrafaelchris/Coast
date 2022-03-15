//
//  BookingDetail.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 05/11/2021.
//

import UIKit
import HorizonCalendar
import PassKit
import MapKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class BookService: UIViewController, UITextViewDelegate{
    
    let blackbrown = UIColor(hexString: "#1D2128")
    let numberplatecolour = UIColor(hexString: "#F9D349")
    let lightgrey = UIColor(hexString: "#F6F6F6")
    let graycolour = UIColor(hexString: "#393C41")
    lazy var calendarView = CalendarView(initialContent: makeContent())
    lazy var calendar = Calendar.current
    private var selectedDate: Date?
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 15, bottom: 10.0, right: 15)
    let numberOfItemsPerRow: CGFloat = 3
    let spacingBetweenCells: CGFloat = 15
    
    var price: Int?
    var service: String?
    var garageID: String?
    var timetaken: Int?
    var numberplate: String?
    var garageimage: String?
    
    var garageServiceInfo = [serviceInfoClass]()
    
    var times = [String]()
    
    var garage: String?
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var GarageText: UILabel = {
        let text = UILabel()
        if let garage = garage {
            if let service = service {
                text.layout(colour: .black, size: 22, text: "\(service) @ \n\(garage)", bold: true)
            }
            
        }
        text.numberOfLines = 0
        return text
    }()
    
    lazy var AddnotesText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "Add any notes", bold: true)
        return text
    }()
    
    lazy var notestextview: UITextView = {
        let textview = UITextView()
        textview.textColor = .black
        textview.font = UIFont.systemFont(ofSize: 18)
        textview.isScrollEnabled = true
        textview.returnKeyType = .done
        textview.delegate = self
        textview.isUserInteractionEnabled = true
        textview.backgroundColor = UIColor(hexString: "F6F6F6")
        textview.layer.cornerRadius = 15
        textview.layer.masksToBounds = true
        return textview
    }()
    
    
    lazy var ChooseDateText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "Choose a Date", bold: true)
        return text
    }()
    
    lazy var nextmonth: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setsizedImage(symbol: "arrow.right", size: 14, colour: .black)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var previousmonth: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setsizedImage(symbol: "arrow.left", size: 14, colour: .black)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var ChooseTimeText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "Choose a Time", bold: true)
        return text
    }()
    
    lazy var timesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(TimeCell.self, forCellWithReuseIdentifier: "timecell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = lightgrey
        collectionview.layer.cornerRadius = 20
        collectionview.layer.masksToBounds = true
        collectionview.showsHorizontalScrollIndicator = false
        //collectionview.isScrollEnabled = false
        return collectionview
    }()
    
    lazy var SummaryText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "Summary", bold: true)
        return text
    }()
    
    lazy var dateview: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var timeview: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var priceview: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hexString: "#E6E6E6").cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layout(axis: .vertical, distribution: .fillEqually, alignment: .center, spacing: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var buttonSize:CGFloat = CGFloat(20)
    
    lazy var DateButton = ConfirmedButton.setimage(image: "calendar")
    lazy var TimeButton = ConfirmedButton.setimage(image: "clock")
    lazy var PriceButton = ConfirmedButton.setimage(image: "sterlingsign.circle.fill")
    
    lazy var DateLabel = ConfirmedLabel.text(textlabel: "Date")
    lazy var TimeLabel = ConfirmedLabel.text(textlabel: "Time")
    lazy var PriceLabel = ConfirmedLabel.text(textlabel: "Price")
    //getTodaysDateforbooking()
    lazy var DateText = ConfirmedText.text(textlabel: "")
    lazy var TimeText = ConfirmedText.text(textlabel: "")
    lazy var Pricetext = ConfirmedText.text(textlabel: "")
    
    lazy var NumberPlateText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 25, text: "FP63 YVF", bold: true)
        text.backgroundColor = numberplatecolour
        text.textAlignment = .center
        text.layer.cornerRadius = 8
        text.layer.masksToBounds = true
        return text
    }()
    
    lazy var ConfirmButton = darkblackbutton.textstring(text: "Confirm")
    
    private var request:PKPaymentRequest = {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.christian.keyloopApp"
        request.supportedNetworks = [.visa,.masterCard,.quicPay]
        request.supportedCountries = ["GB","US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "GB"
        request.currencyCode = "GBP"
        return request
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        calendarsetup()
        setupView()
        daySelection()
        nextmonth.addTarget(self, action: #selector(nextmonthbuttontapped), for: .touchUpInside)
        previousmonth.addTarget(self, action: #selector(previousmonthbuttontapped), for: .touchUpInside)
        ConfirmButton.addTarget(self, action: #selector(confirmtopay), for: .touchUpInside)
        navigationController?.isNavigationBarHidden = false
        if let price = price {
            self.Pricetext.text = "\(price)"
        }
        if let servicename = service {
            if let price = price {
                if let garage = garage {
                    request.paymentSummaryItems = [PKPaymentSummaryItem(label: "\(servicename) @ \(garage)", amount: NSDecimalNumber(value: price))]
                }
            }
        }

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.notestextview.resignFirstResponder()
        }
        return true
    }
    
    @objc func confirmtopay() {
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
        if let Controller = controller {
            Controller.delegate = self
            self.present(Controller, animated: true, completion: nil)
        }
    }
        
    
//    func getGarageInfo(garage:String) {
//        guard let garageID = garageID else {return}
//        let bookingInforef = Firestore.firestore().collection("Garages").document(garageID)
//        bookingInforef.getDocument { document, error in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//            if let data = document?.data() {
//                let garageinfo = GarageInfoData(dictionary: data)
//                //declare variables
//                guard let latitude = garageinfo.Latitude else {return}
//                guard let longitude = garageinfo.Longitude else {return}
//                guard let garagename = garageinfo.Name else {return}
//                //center map on garageCLLocationDegrees()
//                let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
//                self.centerMapOnLocation(location: initialLocation, title: garagename)
//            }
//        }
//    }
    
    func getbookingsfor(garage:String, date:String) {
        guard let garageID = garageID else {return}
        let bookingInforef = Firestore.firestore().collection("Garages").document(garageID)
        getuserbookings(garage: garage, date: date) { bookingtimes in
        bookingInforef.getDocument { document, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let data = document?.data() {
                self.times.removeAll()
                self.TimeText.text = ""
                let garageinfo = GarageInfoData(dictionary: data)
                //declare variables
                guard let openinghour = garageinfo.OpeningHour else {return}
                guard let closinghour = garageinfo.ClosingHour else {return}
                //get all hours between opening and closing hour and append to times array
                var alltimes = self.addTimeto(starttime: openinghour, endtime: closinghour) //times array from opening to closing time
                //print(alltimes)
                let sortedBookings = bookingtimes.sorted()
                for booking in sortedBookings {
                    let booking = booking.components(separatedBy: "-")
                    let bookingstart = booking[0]
                    let bookingend = booking[1]
                    var takentimes = self.addTimeto(starttime: bookingstart, endtime: bookingend)
                    takentimes.removeLast()
                    //print(takentimes)
                    alltimes = alltimes.filter { !takentimes.contains($0) }
                    }
                self.times.append(contentsOf: alltimes)
                }
            DispatchQueue.main.async {
                self.timesCollectionView.reloadData()
                }
            }
        }
    }
    
    func addTimeto(starttime:String,endtime:String) -> [String] {
        var times = [String]()
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm"
        guard var startTimeDate = starttime.toDateFormat(format: "HH:mm") else {return times}
        guard let endTimeDate = endtime.toDateFormat(format: "HH:mm") else {return times}
        
        while startTimeDate < endTimeDate {
            times.append(fmt.string(from: startTimeDate))
            startTimeDate = Calendar.current.date(byAdding: .minute, value: 15, to: startTimeDate)!
        }
        return times
    }
    
    
    func getuserbookings(garage:String, date:String, completion: @escaping(_ bookingtimes:[String]) -> Void ) {
        var times = [String]()
        guard let garageID = garageID else {return}
        let bookingInforef = Firestore.firestore().collection("Bookings").document(garageID)
        let usersbookingref = bookingInforef.collection("Bookings").document(date)
        
        usersbookingref.getDocument { document, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let data = document?.data() {
                for key in data.keys {
                    times.append(key)
                }
            }
            completion(times)
        }
    }




    
    func calendarsetup() {
        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 20
        calendarView.layer.masksToBounds = true
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(GarageText)
        scrollView.addSubview(AddnotesText)
        scrollView.addSubview(notestextview)
        scrollView.addSubview(ChooseDateText)
        scrollView.addSubview(calendarView)
        scrollView.addSubview(nextmonth)
        scrollView.addSubview(previousmonth)
        scrollView.addSubview(ChooseTimeText)
        scrollView.addSubview(timesCollectionView)
        scrollView.addSubview(SummaryText)
        scrollView.addSubview(categoryStackView)
        categoryStackView.addArrangedSubview(dateview)
        categoryStackView.addArrangedSubview(timeview)
        categoryStackView.addArrangedSubview(priceview)

        dateview.addSubview(DateButton)
        dateview.addSubview(DateLabel)
        dateview.addSubview(DateText)
        
        timeview.addSubview(TimeButton)
        timeview.addSubview(TimeLabel)
        timeview.addSubview(TimeText)
        
        priceview.addSubview(PriceButton)
        priceview.addSubview(PriceLabel)
        priceview.addSubview(Pricetext)
        
        scrollView.addSubview(ConfirmButton)
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        GarageText.anchor(top: scrollView.topAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)
        
        ChooseDateText.anchor(top: GarageText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)

        calendarView.anchor(top: ChooseDateText.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 40, right: nil, paddingRight: 40, width: 0, height: 0)
        calendarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendarView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true

        nextmonth.anchor(top: calendarView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 10, right: calendarView.rightAnchor, paddingRight: 10, width: 30, height: 30)

        previousmonth.anchor(top: calendarView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: calendarView.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 10, width: 30, height: 30)
        
        ChooseTimeText.anchor(top: calendarView.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)

        timesCollectionView.anchor(top: ChooseTimeText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        timesCollectionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.1).isActive = true
        timesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        timesCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        AddnotesText.anchor(top: timesCollectionView.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)
        
        notestextview.anchor(top: AddnotesText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 30, right: view.rightAnchor, paddingRight: 30, width: 0, height: 0)
        notestextview.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.1).isActive = true
        
        SummaryText.anchor(top: notestextview.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)

        dateview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true

        timeview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true

        priceview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        
        categoryStackView.anchor(top: SummaryText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        categoryStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        categoryStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        categoryStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true

        //date view
        DateButton.centerYAnchor.constraint(equalTo: dateview.centerYAnchor).isActive = true
        DateButton.leftAnchor.constraint(equalTo: dateview.leftAnchor,constant: 5).isActive = true
        
        DateLabel.centerYAnchor.constraint(equalTo: dateview.centerYAnchor).isActive = true
        DateLabel.leftAnchor.constraint(equalTo: DateButton.rightAnchor,constant: 5).isActive = true
        
        DateText.centerYAnchor.constraint(equalTo: dateview.centerYAnchor).isActive = true
        DateText.rightAnchor.constraint(equalTo: dateview.rightAnchor,constant: -20).isActive = true
        
        //timeview
        TimeButton.centerYAnchor.constraint(equalTo: timeview.centerYAnchor).isActive = true
        TimeButton.leftAnchor.constraint(equalTo: timeview.leftAnchor,constant: 5).isActive = true
        
        TimeLabel.centerYAnchor.constraint(equalTo: timeview.centerYAnchor).isActive = true
        TimeLabel.leftAnchor.constraint(equalTo: TimeButton.rightAnchor,constant: 5).isActive = true
        
        TimeText.centerYAnchor.constraint(equalTo: timeview.centerYAnchor).isActive = true
        TimeText.rightAnchor.constraint(equalTo: timeview.rightAnchor,constant: -20).isActive = true
        
        
        //priceview
        
        PriceButton.centerYAnchor.constraint(equalTo: priceview.centerYAnchor).isActive = true
        PriceButton.leftAnchor.constraint(equalTo: priceview.leftAnchor,constant: 5).isActive = true
        
        PriceLabel.centerYAnchor.constraint(equalTo: priceview.centerYAnchor).isActive = true
        PriceLabel.leftAnchor.constraint(equalTo: PriceButton.rightAnchor,constant: 5).isActive = true
        
        Pricetext.centerYAnchor.constraint(equalTo: priceview.centerYAnchor).isActive = true
        Pricetext.rightAnchor.constraint(equalTo: priceview.rightAnchor,constant: -20).isActive = true
        
        //confirm button
        ConfirmButton.anchor(top: categoryStackView.bottomAnchor, paddingTop: 30, bottom: scrollView.bottomAnchor, paddingBottom: 30, left: nil, paddingLeft: 0, right: nil, paddingRight: 10, width: 0, height: 0)
        ConfirmButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        ConfirmButton.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.6).isActive = true
        ConfirmButton.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.06).isActive = true

    }
    
  
    func daySelection() {
        calendarView.daySelectionHandler = { [weak self] day in
          guard let self = self else { return }
            
            self.selectedDate = self.calendar.date(from: day.components)
            guard let selecteddate = self.selectedDate else {return self.AlertofError("Please try again", "Something went wrong")}
            guard let todaysDate = self.getTodaysDate().toDate() else {return self.AlertofError("Please try again", "Something went wrong")}

            if selecteddate < todaysDate {
                print("date is in past")
                self.AlertofError("Please try again", "You picked a day in the past")
                return
            }
            else {
                self.calendarView.setContent(self.makeContent())
                  DispatchQueue.main.async {
                      guard let formattedDate = self.selectedDate?.getFormattedDate(format: "d MMM yyyy") else {return self.AlertofError("Please try again", "Something went wrong")}
                      self.DateText.text = formattedDate
                      if let garage = self.garage {
                          self.getbookingsfor(garage: garage, date: formattedDate)
                      }
                }
            }
        }
    }
    
    private func makeContent() -> CalendarViewContent {
      let calendar = Calendar.current
      let date = Date()
      let year = calendar.component(.year, from: date)
      let month = calendar.component(.month, from: date)
      let day = calendar.component(.day, from: date)
      let startDate = calendar.date(from: DateComponents(year: year, month: month, day: day))!
      let endDate = calendar.date(from: DateComponents(year: year + 2, month: month, day: day))!

      return CalendarViewContent(
        calendar: calendar,
        visibleDateRange: startDate...endDate,
        monthsLayout: .horizontal(options: .init(maximumFullyVisibleMonths: 1, scrollingBehavior: .paginatedScrolling(.init(restingPosition: .atIncrementsOfCalendarWidth, restingAffinity: .atPositionsAdjacentToPrevious))))
        )
        
        .withInterMonthSpacing(24)
        .withVerticalDayMargin(8)
        .withHorizontalDayMargin(8)
        
        
          .withDayItemModelProvider { day in
          var invariantViewProperties = DayLabel.InvariantViewProperties(
                  font: UIFont.systemFont(ofSize: 18),
                  textColor: .black,
                  backgroundColor: .white)
              
          let Todaysdate = calendar.date(from: day.components)
            if Todaysdate == startDate {
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = self.blackbrown
            }

          let date = calendar.date(from: day.components)
            if date == self.selectedDate {
                invariantViewProperties.textColor = .white
                invariantViewProperties.backgroundColor = .red
            }

              return CalendarItemModel<DayLabel>(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(day: day))
        }
        
          .withDayOfWeekItemModelProvider { month, weekdayIndex in
              let invariantViewProperties = DatePickerWeeklyDateView.InvariantViewProperties()
              
              return CalendarItemModel<DatePickerWeeklyDateView>(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(weekday: weekdayIndex))
          }
        
          .withMonthHeaderItemModelProvider({ month in
              let invariantViewProperties = MonthHeaderLabel.InvariantViewProperties()
              
              return CalendarItemModel<MonthHeaderLabel>(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(month: month))
          })
    }
    
}

extension BookService {
    
    @objc private func nextmonthbuttontapped() {
        guard let monthrange = calendarView.visibleMonthRange else {return}
        let Currentmonth = monthrange.lowerBound
        let dateranged = "\(Currentmonth)"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM"
        guard let date = dateFormatterGet.date(from: dateranged) else { return }
        guard let nextmonth = Calendar.current.date(byAdding: .month, value: 1, to: date) else {return}
        let Date = Date()
        let endmonth = calendar.component(.month, from: Date)
        let endyear = calendar.component(.year, from: Date)
        let endday = calendar.component(.day, from: date)
        let endDate = calendar.date(from: DateComponents(year: endyear + 2, month: endmonth, day: endday))!
        print(nextmonth)
        print(endDate)
        if nextmonth > endDate {
            print("cant scroll")
        }
        else {
            calendarView.scroll(toMonthContaining: nextmonth, scrollPosition: .centered, animated: true)
        }
    }
    
    @objc private func previousmonthbuttontapped() {
        guard let monthrange = calendarView.visibleMonthRange else {return}
        let Currentmonth = monthrange.lowerBound
        let dateranged = "\(Currentmonth)"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM"
        guard let date = dateFormatterGet.date(from: dateranged) else { return }
        guard let previousmonth = Calendar.current.date(byAdding: .month, value: -1, to: date) else {return}
        let Date = Date()
        let thismonth = calendar.component(.month, from: Date)
        let thisyear = calendar.component(.year, from: Date)
        let thisdatestring = "\(thisyear) \(thismonth)"
        guard let thisdate = dateFormatterGet.date(from: thisdatestring) else { return }
        if previousmonth < thisdate {
            print("cant scroll")
        }
        else {
            calendarView.scroll(toMonthContaining: previousmonth, scrollPosition: .centered, animated: true)
        }
        
    }
}


extension BookService:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return times.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timecell", for: indexPath) as! TimeCell
        let time = times[indexPath.item]
        cell.backgroundColor = self.blackbrown
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        //check if theres enough time to do it
        cell.TimeText.text = time
        return cell
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = timesCollectionView.bounds.width / 4
        let height = timesCollectionView.bounds.height / 1.8
            return CGSize(width: width, height: height)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return spacingBetweenCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let time = times[indexPath.item]
            self.TimeText.text = time
        
    }
}


extension BookService: PKPaymentAuthorizationViewControllerDelegate {
    
    
    func adduserbooking() {
        self.showSpinner(onView: view)
        //declare variables
        print("start")
        guard let service = self.service else {return}
        print("service")
        guard let price = self.price else {return}
        print("price")
        guard let startTime = self.TimeText.text else {return}
        print("startTime")
        guard let timetaken = self.timetaken else {return}
        print("timetaken")
        guard let garageuid = self.garageID else {return}
        print("garageuid")
        guard let notes = self.notestextview.text else {return}
        print("notes")
        guard let numberplate = self.numberplate else {return}
        print("numberplate")
        
        guard let startTimeasDate = self.TimeText.text?.toDateFormat(format: "HH:mm") else {return}
        print("startTimeasDate")
        guard let selecteddateformatted = self.selectedDate?.getFormattedDate(format: "d MMM yyyy") else {return}
        print("startTimeasDate")
        
        guard let endtime = Calendar.current.date(byAdding: .minute, value: timetaken, to: startTimeasDate) else {return}
        print("endtime")
        let endtimeformatted = endtime.getFormattedDate(format: "HH:mm")
        guard let garage = self.garage else {return}
        guard let image = self.garageimage else {return}
        print("garage")
        print(garage)
        guard let name = Auth.auth().currentUser?.displayName else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //declare batch
        let batch = Firestore.firestore().batch()
        
        let userbookingsref = Firestore.firestore().collection("userbookings").document()
        
        let bookingdata: [String : Any] = ["service":service,"price":price,"startTime":startTime,"endTime": endtimeformatted,"date":selecteddateformatted,"car":numberplate,"notes":notes,"garage":garage,"checkedIn":false,"id":userbookingsref.documentID,"garageuid":garageuid, "name": name, "customeruid": uid, "garageImage":image]
        

        
        let garagebookingsref = Firestore.firestore().collection("Bookings").document(garage).collection("Bookings").document(selecteddateformatted)
        
        let startandendstring = "\(startTime)-\(endtimeformatted)"
        
        let garagebookingdata:[String:Any] = [startandendstring:userbookingsref.documentID]
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userdocumentbookingref = Firestore.firestore().collection("users").document(uid).collection("Bookings").document(userbookingsref.documentID)

        batch.setData(bookingdata, forDocument: userbookingsref, merge: true)
        
        batch.setData(garagebookingdata, forDocument: garagebookingsref, merge: true)
        
        batch.setData(bookingdata, forDocument: userdocumentbookingref, merge: true)
        
        batch.commit { error in
            if error != nil {
                print(error!.localizedDescription)
                self.removeSpinner()
                return
            }
            self.removeSpinner()
            print("Booking uploaded")
            let bookingconfirmed = BookingConfirmed()
            bookingconfirmed.bookingID = userbookingsref.documentID
            self.navigationController?.pushViewController(bookingconfirmed, animated: true)
        }
        
        
    }
    
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        //method called when finished aka go to confirmation page
        controller.dismiss(animated: true) {
            self.adduserbooking()
        }
  
    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment) async -> PKPaymentAuthorizationResult {
        return PKPaymentAuthorizationResult(status: .success, errors: nil)
    }

}


class garageInfoClass: NSObject {
    
    @objc var openingHour:String?
    @objc var closingHour:String?
    var Latitude:Double?
    var Longitude:Double?
    var name:String?
    
    
    init(dictionary: [String:Any]) {
        super.init()
        
        openingHour = dictionary["OpeningHour"] as? String
        closingHour = dictionary["ClosingHour"] as? String
        Latitude = dictionary["Latitude"] as? Double
        Longitude = dictionary["Longitude"] as? Double
        name = dictionary["Name"] as? String
        
    }
}

class serviceInfoClass: NSObject {
    
    var timetaken: Int?
    var price:Int?
    var name:String?
    var image: String?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        timetaken = dictionary["timetaken"] as? Int
        price = dictionary["price"] as? Int
        name = dictionary["name"] as? String
        image = dictionary["image"] as? String
    }
}

class BookingInfoClass: NSObject {
    
    var uid: String?
    var date: String?
    var car:String?
    var startTime:String?
    var endTime:String?
    var service:String?
    var notes: String?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        uid = dictionary["uid"] as? String
        date = dictionary["date"] as? String
        car = dictionary["car"] as? String
        startTime = dictionary["startTime"] as? String
        endTime = dictionary["endTime"] as? String
        service = dictionary["service"] as? String
        notes = dictionary["notes"] as? String
    }
}

struct DayLabel: CalendarItemViewRepresentable {

  /// Properties that are set once when we initialize the view.
  struct InvariantViewProperties: Hashable {
    let font: UIFont
      var textColor: UIColor
      var backgroundColor: UIColor
  }

  /// Properties that will vary depending on the particular date being displayed.
  struct ViewModel: Equatable {
    let day: Day
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel {
    let label = UILabel()

    label.backgroundColor = invariantViewProperties.backgroundColor
    label.font = invariantViewProperties.font
    label.textColor = invariantViewProperties.textColor

    label.textAlignment = .center
    label.clipsToBounds = true
    label.layer.cornerRadius = 12
    
    return label
  }

  static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
      view.text = "\(viewModel.day.day)"
  }

}

struct DatePickerWeeklyDateView: CalendarItemViewRepresentable {

  /// Properties that are set once when we initialize the view.
  struct InvariantViewProperties: Hashable {
  }

  /// Properties that will vary depending on the particular date being displayed.
  struct ViewModel: Equatable {
    let weekday: Int
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.clipsToBounds = true
        label.layout(colour: .black, size: 12, text: "", bold: true)
    return label
  }

  static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
      let day = Calendar.current.weekdaySymbols[viewModel.weekday].prefix(3)
          let caps = String(day).uppercased()
      view.text = "\(caps)"
  }

}

struct MonthHeaderLabel: CalendarItemViewRepresentable {

  /// Properties that are set once when we initialize the view.
  struct InvariantViewProperties: Hashable {
  }

  /// Properties that will vary depending on the particular date being displayed.
  struct ViewModel: Equatable {
    let month: Month?
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.clipsToBounds = true
        label.layout(colour: .black, size: 20, text: "", bold: false)
    return label
  }

  static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
      guard let month = viewModel.month?.month else {return}
      guard let year = viewModel.month?.year else {return}
      let monthreal = Calendar.current.monthSymbols[month-1]
      view.text = "\(monthreal) \(year)"
  }

}
