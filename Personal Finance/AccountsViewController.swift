//
//  AccountsViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/21/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var accounts: [Account]!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        accounts = DBWrapper.getAllAccounts()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editTable(sender: UIBarButtonItem)
    {
        if !tableView.editing
        {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
        }
        else
        {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
        }
        
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "accountsToTransactions"
        {
            let indexPath = sender as! NSIndexPath
            let account = accounts[indexPath.row]
            let transactionsVC = segue.destinationViewController as! TransactionsViewController
            transactionsVC.transactions = DBWrapper.getAllTransactionsOf(account: account)
            transactionsVC.navigationItem.title = account.name
        }
        
    }
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return accounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let account = accounts[indexPath.row]
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "AccountCell")
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = String(account.balance) + " " + account.currency
        cell.imageView?.image = UIImage(named: "none")
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("accountsToTransactions", sender: indexPath)
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let account = accounts[indexPath.row]
        if editingStyle == .Delete
        {
            let alertController = UIAlertController(title: "Delete Account",
                                                    message: "Are you sure you want to permanently delete \(account.name) account?\n" +
                                                    "This will also delete all transactions of this account.",
                                                    preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                action in
                let deleted = DBWrapper.deleteAccount(account)
                if deleted
                {
                    self.accounts.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message: "unkown error", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "ok", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    

}























