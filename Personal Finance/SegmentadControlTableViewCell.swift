//
//  SegmentadControlTableViewCell.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/27/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class SegmentadControlTableViewCell: UITableViewCell
{
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

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
