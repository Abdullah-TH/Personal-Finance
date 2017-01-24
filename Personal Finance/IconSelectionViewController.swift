//
//  IconSelectionViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/28/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

protocol IconSelectionProtocol
{
    func selectedIconName(iconName: String)
}

class IconSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    var iconNames: [String] = [
        "FoodGroceries",
        "clothes"
    ]
    
    var delegate: IconSelectionProtocol?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UICollectionViewDataSource and UICollectionViewDelegate methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return iconNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("iconCell", forIndexPath: indexPath) as! IconCollectionViewCell
        let iconName = iconNames[indexPath.row]
        cell.imageView.image = UIImage(named: iconName)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let selectedIconName = iconNames[indexPath.row]
        delegate?.selectedIconName(selectedIconName)
        self.navigationController?.popViewControllerAnimated(true)
    }

}























