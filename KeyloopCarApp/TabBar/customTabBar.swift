//
//  customTabBar.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 02/02/2022.
//

import UIKit

class customTabBar: UITabBarController {

  var indicatorImage: UIImageView?
    
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let numberOfItems = CGFloat(4)
    let tabBarItemSize = CGSize(width: (tabBar.frame.width / numberOfItems) - 20, height: tabBar.frame.height)
    indicatorImage = UIImageView(image: createSelectionIndicator(color: UIColor(red:0.18, green:0.66, blue:0.24, alpha:1.0), size: tabBarItemSize, lineHeight: 4))
    indicatorImage?.center.x =  tabBar.frame.width/4/2
    tabBar.addSubview(indicatorImage!)
  }
    
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    UIView.animate(withDuration: 0.3) {
        let number = -(tabBar.items?.firstIndex(of: item)?.distance(to: 0))! + 1
      if number == 1 {
        self.indicatorImage?.center.x =  tabBar.frame.width/4/2
      } else if number == 2 {
        self.indicatorImage?.center.x =  tabBar.frame.width/4/2 + tabBar.frame.width/4
      } else if number == 3 {
        self.indicatorImage?.center.x =  tabBar.frame.width/4/2 + tabBar.frame.width/2
      } else {
        self.indicatorImage?.center.x = tabBar.frame.width - tabBar.frame.width/4/2
      }
    }
  }

  func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
    let rect: CGRect = CGRect(x: 0, y: size.height - lineHeight, width: size.width, height: lineHeight )
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}

class AnimatedTabBarController: UITabBarController {

    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // find index if the selected tab bar item, then find the corresponding view and get its image, the view position is offset by 1 because the first item is the background (at least in this case)
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first else {
            return
        }

        imageView.layer.add(bounceAnimation, forKey: nil)
    }
}
