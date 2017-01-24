//
//  DatePickerTableViewCell.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/23/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell
{
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        datePicker.maximumDate = NSDate.getDateOfCurrentMonthAndLastDay()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
