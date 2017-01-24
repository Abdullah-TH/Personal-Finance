//
//  IconCollectionViewCell.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/28/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let selectedBackgroundView = UIView(frame: CGRectZero)
        selectedBackgroundView.backgroundColor = UIColor.lightGrayColor()
        self.selectedBackgroundView = selectedBackgroundView
    }
    
}
