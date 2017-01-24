//
//  RecurringSelectionViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/23/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

protocol RecurringSelectionDelegate
{
    func selectedRecurring(recurring: String)
}

class RecurringSelectionViewController: UIViewController
{
    var delegate: RecurringSelectionDelegate?
    
    var recurrings = ["Never", "Daily", "Weekly", "Every 2 Weeks", "Every 3 Weeks", "Every 4 Weeks", "Monthly", "Every 2 Months", "Every 3 Months",
    "Every 4 Months", "Every 5 Months", "Every 6 Months", "Yearly"]
    
    var selectedRecurring: String?

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
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return recurrings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        let recurring = recurrings[indexPath.row]
        cell.textLabel?.text = recurring
        
        if let selectedRecurring = selectedRecurring
        {
            if selectedRecurring == recurring
            {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        let selectedRecurring = recurrings[(tableView.indexPathForSelectedRow?.row)!]
        delegate?.selectedRecurring(selectedRecurring)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
    

}
