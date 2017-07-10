//
//  GoldViewController.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 4/10/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import UIKit

class GoldViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var goldCollectionView: UICollectionView!
    
    let imagesData = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        
        goldCollectionView.delegate = self
        goldCollectionView.dataSource = self
        
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gold_cell", for: indexPath) as! GoldCollectionViewCell
        
        cell.collectionImg.image = UIImage(named: imagesData[indexPath.row])
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}
