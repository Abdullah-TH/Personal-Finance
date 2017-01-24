//
//  AccountSelectionViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/23/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

protocol AccountSelectionDelegate
{
    func selectedAccount(account: Account)
}

class AccountSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AccountSelectionDelegate?
    
    var accounts: [Account]!
    var selectedAccount: Account?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        accounts = DBWrapper.getAllAccounts()
    }
    
  

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return accounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "AccountCell")
        let account = accounts[indexPath.row]
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = String(account.balance)
        cell.imageView?.image = UIImage(named: "none")
        
        if let selectedAccount = selectedAccount
        {
            if selectedAccount.id == account.id
            {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        let selectedAccount = accounts[(tableView.indexPathForSelectedRow?.row)!]
        delegate?.selectedAccount(selectedAccount)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }

    

    

}
