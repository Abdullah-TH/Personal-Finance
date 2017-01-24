//
//  PayeeSelectionViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/23/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

protocol PayeeSelectionDelegate
{
    func selectedPayee(payee: Payee)
}

class PayeeSelectionViewController: UIViewController
{
    var delegate: PayeeSelectionDelegate?
    
    var payees: [Payee]!
    var selectedPayee: Payee?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        payees = DBWrapper.getAllPayees()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return payees.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        let payee = payees[indexPath.row]
        cell.textLabel?.text = payee.name
        
        if let selectedPayee = selectedPayee
        {
            if selectedPayee.id == payee.id
            {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        let selectedPayee = payees[(tableView.indexPathForSelectedRow?.row)!]
        delegate?.selectedPayee(selectedPayee)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
    

}
