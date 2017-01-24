//
//  TextFieldTableViewCell.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/22/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var textField: UITextField!

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
