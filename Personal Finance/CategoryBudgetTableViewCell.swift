//
//  CategoryBudgetTableViewCell.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/21/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class CategoryBudgetTableViewCell: UITableViewCell
{
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountLeftLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    

    override func awakeFromNib()
    {
        super.awakeFromNib()
        progress.transform = CGAffineTransformScale(progress.transform, 1, 3)
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
