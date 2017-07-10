//
//  PlatinumViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/10/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class PlatinumViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var platinumCollectionView: UICollectionView!

    let imagesData = ["one", "two", "three", "four", "five", "six", "seven", "sixteen", "seventeen", "eighteen", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        
        platinumCollectionView.delegate = self
        platinumCollectionView.dataSource = self
        
        let colorNormal : UIColor = UIColor.init(red: 0.7, green: 0.9, blue: 0.98, alpha: 1.0)
        let colorSelected : UIColor = UIColor.white
        let titleFontAll : UIFont = UIFont(name: "HelveticaNeue-Medium", size: 12.0)!
        
        let attributesNormal = [
            NSForegroundColorAttributeName : colorNormal,
            NSFontAttributeName : titleFontAll
        ]
        
        let attributesSelected = [
            NSForegroundColorAttributeName : colorSelected,
            NSFontAttributeName : titleFontAll
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes (attributesSelected, for: .selected)
        
        UITabBar.appearance().barTintColor = UIColor.init(red: 0.19, green: 0.65, blue: 0.9, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "platinum_cell", for: indexPath) as! PlatinumCollectionViewCell
        
        cell.platinumImageView.image = UIImage(named: imagesData[indexPath.row])
        
        return cell
    }

}
