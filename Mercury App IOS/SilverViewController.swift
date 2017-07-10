//
//  SilverViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/10/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class SilverViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var silverCollectionView: UICollectionView!


    let imagesData = ["seventeen", "four", "five", "six", "seven", "two", "three", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "one", "fourteen", "fifteen", "sixteen", "eighteen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        
        silverCollectionView.delegate = self
        silverCollectionView.dataSource = self
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "silver_cell", for: indexPath) as! SilverCollectionViewCell
        
        cell.silverImageView.image = UIImage(named: imagesData[indexPath.row])
        
        return cell
    }


}
