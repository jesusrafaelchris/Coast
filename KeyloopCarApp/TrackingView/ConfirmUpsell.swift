//
//  ConfirmUpsell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 08/03/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import PassKit

class ConfirmUpsell: UIViewController {
    
    var services = [GarageServiceData]()
    var id: String?
    var endTime: String?
    var fault: String?
    var price: Int?
    
    lazy var ReviewText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "Additional Service\nRequest", bold: true)
        text.numberOfLines = 0
        return text
    }()
    
    lazy var ServicesCollectionView: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(garageservicecell.self, forCellWithReuseIdentifier: "garageservicecell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.isScrollEnabled = false
        return collectionview
    }()
    
    lazy var ReasonText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "Reason", bold: true)
        text.numberOfLines = 0
        return text
    }()
    
    lazy var Reasonlabel: UILabel = {
        let text = UILabel()
        if let fault = fault {
            text.layout(colour: .black, size: 14, text: fault, bold: false)
        }
        text.numberOfLines = 0
        return text
    }()
    
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
    
    lazy var acceptbutton = darkblackbutton.textstringsizecolour(text: "Accept", size: 14, cornerRadius: 15,colour: UIColor(hexString: "222222"))
    
    lazy var denybutton = darkblackbutton.textstringsizecolour(text: "Deny", size: 14, cornerRadius: 15,colour: UIColor(hexString: "AE1D1E"))
    
    lazy var equalstack = equalStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        equalstack.layout(axis: .horizontal, distribution: .fillEqually, alignment: .center, spacing: 10)
        DispatchQueue.main.async {
            self.ServicesCollectionView.reloadData()
        }
        view.backgroundColor = .white
        
        acceptbutton.addTarget(self, action: #selector(confirmtopay), for: .touchUpInside)
        denybutton.addTarget(self, action: #selector(denyupsell), for: .touchUpInside)
        if let price = price {
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Pay Coast", amount: NSDecimalNumber(value: price))]
        }
    }
    
    @objc func confirmtopay() {
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
        if let Controller = controller {
            Controller.delegate = self
            self.present(Controller, animated: true, completion: nil)
        }
    }
    
    func acceptupsell() {
        guard let id = self.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("userbookings").document(id)
        let userbookingref = Firestore.firestore().collection("users").document(uid).collection("Bookings").document(id)
        
        guard let newEndtime = self.endTime else {return}
        
        guard let startTimeasDate = newEndtime.toDateFormat(format: "HH:mm") else {return}
        
        guard let endtime = Calendar.current.date(byAdding: .minute, value: services[0].Time!, to: startTimeasDate) else {return}

        let endtimeformatted = endtime.getFormattedDate(format: "HH:mm")
        
        print(endtimeformatted)
        
        ref.setData(["stage1error":false,"stage2error":false,"endTime":endtimeformatted],merge: true)
        userbookingref.setData(["stage1error":false,"stage2error":false,"endTime":endtimeformatted],merge: true) { error in
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
    @objc func denyupsell() {
        
        guard let id = self.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("userbookings").document(id)
        let userbookingref = Firestore.firestore().collection("users").document(uid).collection("Bookings").document(id)
        
        ref.setData(["stage1error":false,"stage2error":false],merge: true)
        userbookingref.setData(["stage1error":false,"stage2error":false],merge: true) { error in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func setupView() {
        view.addSubview(ReviewText)
        view.addSubview(ServicesCollectionView)
        view.addSubview(ReasonText)
        view.addSubview(Reasonlabel)
        view.addSubview(equalstack)
        
        equalstack.addArrangedSubview(acceptbutton)
        equalstack.addArrangedSubview(denybutton)
        
        ReviewText.anchor(top: view.topAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        
        ServicesCollectionView.anchor(top: ReviewText.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, width: 0, height: 0)
        
        ReasonText.anchor(top: ServicesCollectionView.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        Reasonlabel.anchor(top: ReasonText.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        equalstack.anchor(top: nil, paddingTop: 10, bottom: view.bottomAnchor, paddingBottom: 30, left: view.leftAnchor, paddingLeft: 10, right: view.rightAnchor, paddingRight: 10, width: 0, height: 0)
        acceptbutton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        denybutton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        
    }

}

extension ConfirmUpsell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func minutesToHoursAndMinutes (_ minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
        
        
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return services.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "garageservicecell", for: indexPath) as! garageservicecell
        
        let service = services[indexPath.row]
        
        cell.ServiceName.text = service.Name
        if let name = service.Name {
            if name == "MOT" {
                cell.ServiceImage.image = UIImage(named: name)?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
            }
            else {
                cell.ServiceImage.image = UIImage(named: name)
            }
        }
        
        if let price = service.Price {
            cell.Pricetext.text = "£\(price)"
        }
        
        if let time = service.Time {
            if time > 45 {
                let hours = minutesToHoursAndMinutes(time).hours
                let minutes = minutesToHoursAndMinutes(time).leftMinutes
                cell.Timetext.setTitle("\(hours).\(minutes) hrs", for: .normal)
            }
            else {
                cell.Timetext.setTitle("\(time) mins", for: .normal)
            }
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemheight = view.bounds.height / 8
        let itemSize = CGSize(width: itemWidth, height: itemheight)
        return itemSize // Replace with count of your data for collectionViewA
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

}

extension ConfirmUpsell:PKPaymentAuthorizationViewControllerDelegate {

    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        //method called when finished aka go to confirmation page
        controller.dismiss(animated: true) {
            self.acceptupsell()
        }
  
    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment) async -> PKPaymentAuthorizationResult {
        return PKPaymentAuthorizationResult(status: .success, errors: nil)
    }

}
    
