//
//  BillTableViewCell.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/21/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell
{
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
