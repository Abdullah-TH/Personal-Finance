//
//  textViewTableViewCell.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/23/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class textViewTableViewCell: UITableViewCell
{
    @IBOutlet weak var textView: UITextView!

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
