//
//  TransactionsViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/20/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var transactions: [Transaction]!
    var accounts: [Account]!
    var categories: [TransactionCategory]!
    var payees: [Payee]!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        accounts = DBWrapper.getAllAccounts()
        categories = DBWrapper.getAllCategories()
        payees = DBWrapper.getAllPayees()
        // transactions is set by the parent View Controller before performing a segue to this Controller
        // because this view controller present transactions of different months based on user selection
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
        if segue.identifier == "updateTransaction"
        {
            let addTransactionVC = segue.destinationViewController as! AddTransactionViewController
            let indexPath = sender as! NSIndexPath
            let transaction = transactions[indexPath.row]
            
            // set the current values of the transaction to the addTransactionVC
            addTransactionVC.type = transaction.type
            for account in accounts
            {
                if account.id == transaction.accountID
                {
                    addTransactionVC.account = account
                }
            }
            for category in categories
            {
                if category.id == transaction.categoryID
                {
                    addTransactionVC.category = category
                }
            }
            addTransactionVC.amount = transaction.amount
            addTransactionVC.currency = transaction.currency
            for payee in payees
            {
                if payee.id == transaction.payeeID
                {
                    addTransactionVC.payee = payee
                }
            }
            addTransactionVC.date = transaction.date
            addTransactionVC.recurring = transaction.recurring ?? "None"
            addTransactionVC.photo = transaction.image
            addTransactionVC.notes = transaction.notes
        }
    }
    
   
    
    // MARK: UITableViewDelegate and UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return transactions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransactionCell") as! TransactionTableViewCell
        cell.accessoryType = .DisclosureIndicator
        
        let transaction = transactions[indexPath.row]
        var accountName = ""
        for account in accounts
        {
            if account.id == transaction.accountID
            {
                accountName = account.name
            }
        }
        var categoryName = ""
        var categoryIcon = UIImage()
        for category in categories
        {
            if category.id == transaction.categoryID
            {
                categoryName = category.name
                categoryIcon = UIImage(named: category.iconName)!
            }
        }
        
        var amountWithCurrency = "\(transaction.amount) \(transaction.currency)"
        
        if transaction.type == .Expense
        {
            cell.rightLabel.textColor = UIColor.redColor()
        }
        else
        {
            amountWithCurrency = "+" + amountWithCurrency
            cell.rightLabel.textColor = UIColor.greenColor()
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormatter.stringFromDate(transaction.date)
        
        cell.categoryImageView.image = categoryIcon
        cell.topLabel.text = categoryName
        cell.bottomLabel.text = accountName + ", " + dateString
        cell.rightLabel.text = amountWithCurrency
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("updateTransaction", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            let alertController = UIAlertController(title: "Are you sure?",
                                                    message: "This transaction will be deleted permanently",
                                                    preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                action in
                let deleted = DBWrapper.deleteTransaction(self.transactions[indexPath.row])
                if deleted
                {
                    self.transactions.removeAtIndex(indexPath.row)
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






















