//
//  TabBarController.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 02/02/2022.
//

import UIKit

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

// View Did Load
override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    // remove top line
    if #available(iOS 13.0, *) {
        // ios 13.0 and above
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundEffect = nil
        // need to set background because it is black in standardAppearance
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
    } else {
        // below ios 13.0
        let image = UIImage()
        tabBar.shadowImage = image
        tabBar.backgroundImage = image
        // background
        tabBar.backgroundColor = .white
    }
}

// Tab Bar Specific Code
override func viewDidAppear(_ animated: Bool) {
    
    let home = MainPage()
    let homeimage = UIImage(systemName: "house")
    let homeselected = UIImage(systemName: "house.fill")
    
    home.tabBarItem =  UITabBarItem(title: "", image: homeimage, selectedImage: homeselected)
   
    let search = SearchPage()
    let searchimage = UIImage(systemName: "square.text.square")
    let searchselected = UIImage(systemName: "square.text.square.fill")
    search.tabBarItem = UITabBarItem(title: "", image: searchimage, selectedImage: searchselected)

    let ShowBookings = ShowBookings()
    let bookingsimage = UIImage(systemName: "wrench")
    let ShowBookingsselected = UIImage(systemName: "wrench.fill")
    ShowBookings.tabBarItem = UITabBarItem(title: "", image: bookingsimage, selectedImage: ShowBookingsselected)

    let bookings = MyGarage()
    let bookings2 = MyGarage()

    let tabbarList = [home, search, ShowBookings, bookings, bookings2 ]
    
    viewControllers = tabbarList.map {
        UINavigationController(rootViewController: $0)
    }
    self.setupBookingsButton()
}

// TabBarButton – Setup Middle Button
func setupBookingsButton() {
    
    let menuButton = UIButton()
    
    menuButton.layout(textcolour: .white, backgroundColour: UIColor(hexString: "222222"), size: 14, text: "", image: UIImage(systemName: "car.2.fill")?.withTintColor(.white).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
    

    self.view.addSubview(menuButton)
    
    menuButton.anchor(top: tabBar.topAnchor, paddingTop: 2, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: 30, width: 100, height: 40)


    menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)

    self.view.layoutIfNeeded()
}

// Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
    self.selectedIndex = 4
        sender.setImage(UIImage(systemName: "car.2")?.withTintColor(.white).withRenderingMode(.alwaysOriginal), for: .highlighted)
        
   }
    
 }
