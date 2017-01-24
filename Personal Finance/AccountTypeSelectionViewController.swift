//
//  AccountTypeSelectionViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/25/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

protocol AccountTypeSelectionDelegate
{
    func selectedType(type: AccountType)
}

class AccountTypeSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    let types = [AccountType.Cash, AccountType.Checking, AccountType.Debit, AccountType.Credit, AccountType.CreditCard, AccountType.Saving]
    var selectedType: AccountType?
    
    var delegate: AccountTypeSelectionDelegate?

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
        return types.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        let type = types[indexPath.row]
        cell.textLabel?.text = type.rawValue
        
        if let selectedType = selectedType
        {
            if selectedType == type
            {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        let selectedType = types[(tableView.indexPathForSelectedRow?.row)!]
        delegate?.selectedType(selectedType)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }

}



















