//
//  DetailedGarage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 03/02/2022.
//

import UIKit
import Firebase
import Nuke
import FirebaseFirestore

class DetailedGarage: UIViewController {
    
    var garageID:String?
    var image: String?
    var faraway: String?
    var rating: Double?
    var name: String?
    var lat: Double?
    var long: Double?
    var opentime: String?
    var closetime: String?
    var numberplate: String?
    
    var services = [GarageServiceData]()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        //scrollView.backgroundColor = .red
        return scrollView
    }()
    
    lazy var GarageImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var GarageName: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 22, text: "", bold: true)
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    lazy var FarAwayText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "", bold: false)
        return text
    }()
    
    lazy var RatingText: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: nil, size: 14, text: "", image: UIImage(systemName: "star.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    
    lazy var ServiceInfoContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexString: "F6F6F6")
        view.layer.cornerRadius = 17.5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var InfoTextImage: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: nil, size: 12, text: "   Info", image: UIImage(systemName: "info.circle")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    lazy var InfoText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 10, text: "Tap for opening hours, location and more", bold: false)
        return text
    }()
    
    lazy var InfoButton: UIButton = {
        let button = UIButton()
        button.setsizedImage(symbol: "arrow.right", size: 12, colour: .black)
        return button
    }()
    
    lazy var ServiceTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 22, text: "Services", bold: true)
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    lazy var backbutton: UIButton = {
        let button = UIButton()
        button.setsizedImage(symbol: "arrow.backward", size: 14, colour: .black)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        getgarageservices()
        setobjectvalues()
        InfoButton.addTarget(self, action: #selector(chooselocation), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true
        backbutton.addTarget(self, action: #selector(goback), for: .touchUpInside)
    }
    
    @objc func goback() {
        print("pressed back")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func chooselocation() {
        let infopage = InfoPage()
        infopage.lat = lat
        infopage.long = long
        infopage.name = name
        infopage.openingtime = opentime
        infopage.closingtime = closetime
        
        let nav = UINavigationController(rootViewController: infopage)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {

            sheet.detents = [ .medium()]

        }
        present(nav, animated: true, completion: nil)
    }
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(GarageImage)
        view.addSubview(backbutton)
        scrollView.addSubview(GarageName)
        scrollView.addSubview(FarAwayText)
        scrollView.addSubview(RatingText)
        scrollView.addSubview(ServiceInfoContainerView)
        ServiceInfoContainerView.addSubview(InfoTextImage)
        ServiceInfoContainerView.addSubview(InfoText)
        ServiceInfoContainerView.addSubview(InfoButton)
        scrollView.addSubview(ServiceTitle)
        scrollView.addSubview(ServicesCollectionView)
        
        scrollView.anchor(top: view.topAnchor, paddingTop: -50, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        GarageImage.anchor(top: scrollView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        GarageImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28).isActive = true
        
        backbutton.anchor(top: view.topAnchor, paddingTop: 50, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 35, height: 35)
        
        GarageName.anchor(top: GarageImage.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        GarageName.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        GarageName.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        FarAwayText.anchor(top: GarageName.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        RatingText.anchor(top: GarageName.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: FarAwayText.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 10, width: 0, height: 0)
        
        ServiceInfoContainerView.anchor(top: FarAwayText.bottomAnchor, paddingTop: 15, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 0)
        ServiceInfoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
        InfoTextImage.anchor(top: ServiceInfoContainerView.topAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: ServiceInfoContainerView.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        InfoButton.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 10, right: ServiceInfoContainerView.rightAnchor, paddingRight: 15, width: 0, height: 0)
        InfoButton.centerYAnchor.constraint(equalTo: ServiceInfoContainerView.centerYAnchor).isActive = true
        
        InfoText.anchor(top: InfoTextImage.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: ServiceInfoContainerView.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        ServiceTitle.anchor(top: ServiceInfoContainerView.bottomAnchor, paddingTop: 15, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        ServicesCollectionView.anchor(top: ServiceTitle.bottomAnchor, paddingTop: 20, bottom: scrollView.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 10, width: 0, height: 0)
            
        
    }

}

//MARK: GET DATA

extension DetailedGarage {
    
    func minutesToHoursAndMinutes (_ minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func setobjectvalues() {
//        guard let urlstring = self.image else {return}
//        guard let faraway = self.faraway else {return}
//        guard let rating = self.rating else {return}
//        guard let name = self.name else {return}
        
        //print(name)
        //print(faraway)
        //print(rating)
        //print(urlstring)
        
        if let urlstring = self.image{
        if let url = URL(string: urlstring) {
            Nuke.loadImage(with: url, into: self.GarageImage)
            }
        }
        
        self.GarageName.text = name
        if let rating = rating {
            self.RatingText.setTitle(" \(rating)", for: .normal)

        }
        self.FarAwayText.text = faraway
        
    }
    
    func getgarageservices() {
        guard let id = self.garageID else {return}
        let ref = Firestore.firestore().collection("Garages").document(id).collection("Services")
        ref.getDocuments { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let data = document.data()
                let service = GarageServiceData(dictionary: data)
                self.services.append(service)
                DispatchQueue.main.async {
                    self.ServicesCollectionView.reloadData()
                }
            }
        }
    }
}

extension DetailedGarage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        
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
       
 
//        let urlstring = "https://firebasestorage.googleapis.com/v0/b/keyloopcar.appspot.com/o/Mini_%20Main.png?alt=media&token=7dd7a5d2-d545-4519-80cb-211a64611123"
//            if let url = URL(string: urlstring) {
//                Nuke.loadImage(with: url, into: cell.ServiceImage)
//            }
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemheight = view.bounds.height / 12
        let itemSize = CGSize(width: itemWidth, height: itemheight)
        return itemSize // Replace with count of your data for collectionViewA
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let service = services[indexPath.item]
        let bookservice = BookService()
        bookservice.price = service.Price
        bookservice.service = service.Name
        guard let name = self.name else {return}
        bookservice.garage = name
        bookservice.garageID = self.garageID
        bookservice.timetaken = service.Time
        bookservice.numberplate = self.numberplate
        bookservice.garageimage = self.image
        self.navigationController?.pushViewController(bookservice, animated: true)
    }

        
    }
