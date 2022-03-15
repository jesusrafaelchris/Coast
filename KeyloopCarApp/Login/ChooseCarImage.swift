//
//  testcarimage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 10/11/2021.
//

import UIKit
import Nuke
import Firebase
import FirebaseFirestore
//import ColorKit


class ChooseCarImage: UIViewController {
    
    var imageLinks = [String]()
    var car: CarInfo?
    
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(TestCell.self, forCellWithReuseIdentifier: "cell")
        collectionview.delegate = self
        collectionview.dataSource = self
        //collectionview.backgroundColor = .clear
        //collectionview.isScrollEnabled = false
        return collectionview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cardetails = car?.VehicleDetails else {return}
        guard let year = cardetails.Year else {return}
        guard let make = cardetails.Make else {return}
        guard let model = cardetails.Model else {return}
        guard let colour = cardetails.Colour else {return}

        getcarImages(year: year, make: make, model: model, colour: colour) { images in
            for image in images {
                let link = image.link
                self.imageLinks.append(link)
                self.removeSpinner()
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.removeSpinner()
            }
        }
        self.removeSpinner()
        self.title = "Choose Your Car"
       

        //view.backgroundColor = self.CarImage.image?.averageColor
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.pinEdgesToSuperView()
    }
    
    func getcarImages(year: String, make:String,model:String,colour:String,completion: @escaping(_ images: [Image]) -> Void) {
        self.showSpinner(onView: view)
        if let url = URL(string: "https://api.carsxe.com/images?key=2ndamd6wc_l23wh6j7n_31i7s7efr&year=\(year)&make=\(make)&model=\(model)&color=\(colour)&transparent=true&angle=side&format=json") {
           URLSession.shared.dataTask(with: url) { data, response, error in
           if let data = data {
                     do {
                        let res = try JSONDecoder().decode(RootClass.self, from: data)
                         guard let images = res.images else {return}
                         completion(images)
                         self.removeSpinner()
                     } catch let error {
                        print(error)
                         self.removeSpinner()
                     }
                  }
           }.resume()
        }
    }
}


extension ChooseCarImage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestCell
        let link = imageLinks[indexPath.item]
        if let url = URL(string: changeToHttps(urlstring: link)) {
            Nuke.loadImage(with: url, into: cell.CarImage)
        }
//        var bcolour: UIColor?
        
//        do {
//            if let colors = try cell.CarImage.image?.dominantColors() {
//                let palette = ColorPalette(orderedColors: colors, ignoreContrastRatio: true)
//                //let colorDifference = palette?.primary.difference(from: .black, using: .CIE94)
//                 bcolour = palette?.primary
//            }
//        } catch {print("error")}
        
        //cell.backgroundColor = .red//bcolour
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing

        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)

        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let link = imageLinks[indexPath.item]
        print(link)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let numberplate = car?.VehicleDetails?.Registration else {return}
        let ref = Firestore.firestore().collection("users").document(uid).collection("cars").document(numberplate)
        ref.setData(["imageurl":link], merge: true) { error in
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func changeToHttps(urlstring:String) -> String {
        if urlstring.prefix(5) == "https" {
            return urlstring
        }
        else {
            let https = "https" + urlstring.dropFirst(4)
            return https
        }
    }
    
}
