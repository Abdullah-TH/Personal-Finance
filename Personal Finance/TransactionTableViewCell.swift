//
//  TransactionTableViewCell.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/21/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell
{
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
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
