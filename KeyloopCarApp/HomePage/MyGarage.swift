//
//  MyGarage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 02/02/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Nuke

class MyGarage: UIViewController {
    
    var cardata = [CarGarageData]()
    
    lazy var MyCarsLabel: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 28, text: "My Garage", bold: true)
        return text
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var CarsCollectionView: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(CarCell.self, forCellWithReuseIdentifier: "carCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.layer.cornerRadius = 0
        collectionview.layer.masksToBounds = true
        collectionview.isScrollEnabled = false
        return collectionview
    }()
    
    lazy var addcar: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: .clear, size: 12, text: "  Add Car", image: UIImage(systemName: "plus.circle")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
        button.layer.borderColor = UIColor(hexString: "F6F5F8").cgColor
        button.layer.borderWidth = 2
        return button
    }()
    
    let donebutton = darkblackbutton.textstring(text: "Done")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        buttonactions()
        //getcars()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getcars()
    }
    
    func buttonactions() {
        addcar.addTarget(self, action: #selector(addcartogarage), for: .touchUpInside)
        donebutton.addTarget(self, action: #selector(dismisspage), for: .touchUpInside)
    }
    
    @objc func addcartogarage() {
        let addcarreg = AddCarReg()
        navigationController?.pushViewController(addcarreg, animated: true)
    }
    
    @objc func dismisspage() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(MyCarsLabel)
        scrollView.addSubview(CarsCollectionView)
        scrollView.addSubview(addcar)
        //view.addSubview(donebutton)
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        MyCarsLabel.anchor(top: scrollView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 50)
        
        CarsCollectionView.anchor(top: MyCarsLabel.bottomAnchor, paddingTop: 40, bottom: scrollView.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 30, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        addcar.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: 10, width: 0, height: 0)
        addcar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        addcar.centerYAnchor.constraint(equalTo: MyCarsLabel.centerYAnchor).isActive = true
        addcar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        
//        donebutton.anchor(top: nil, paddingTop: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
//        donebutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        donebutton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
//        donebutton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
    }
    
    func getcars() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("users").document(uid).collection("cars")
        ref.getDocuments { snapshot, error in
            self.cardata.removeAll()
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                guard let documents = snapshot?.documents else {return}
                for document in documents {
                    let data = document.data()
                    let car = CarGarageData(dictionary: data)
                    self.cardata.append(car)
                    DispatchQueue.main.async {
                        self.CarsCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension MyGarage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardata.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carCell", for: indexPath) as! CarCell
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor(hexString: "F6F6F6")
        }
        
        if indexPath.item % 2 != 0 {
            cell.layer.borderColor = UIColor(hexString: "F6F5F8").cgColor
            cell.layer.borderWidth = 3
        }
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        cell.layer.masksToBounds = true
        
        let car = cardata[indexPath.row]
        cell.makeText.text = car.Make?.lowercased().capitalizingFirstLetter()
        cell.modelText.text = car.Model?.lowercased().capitalizingFirstLetter()

        cell.NumberPlateText.text = car.Registration
        if let urlstring = car.imageurl {
            if let url = URL(string: urlstring) {
                Nuke.loadImage(with: url, into: cell.CarImage)
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemheight = view.bounds.height / 3.2
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
        let car = cardata[indexPath.item]

       
    }

        
    }
