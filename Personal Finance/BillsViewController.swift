//
//  BillsViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/21/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class BillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var bills: [Bill]!
    var payees: [Payee]!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        bills = DBWrapper.getAllBills()
        payees = DBWrapper.getAllPayees()
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
    
    
    // MARK: Nvigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "billsToABill"
        {
            let aBillVC = segue.destinationViewController as! ABillViewController
            let indexPath = sender as! NSIndexPath
            let bill = bills[indexPath.row]
            aBillVC.bill = bill
            
        }
    }
    
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("BillCell") as! BillTableViewCell
        cell.accessoryType = .DisclosureIndicator
        
        let bill = bills[indexPath.row]
        let billName = bill.name
        
        let payeeID = bill.payeeID
        var payeeName = ""
        for payee in payees
        {
            if payee.id == payeeID
            {
                payeeName = payee.name
            }
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd"
        let dueDate = "Due on: " + dateFormatter.stringFromDate(bill.date)
        
        var billAmount = "Varies"
        if bill.amount > 0 // if bill amount is NULL in database, the value returned is zero
        {
            billAmount = String(bill.amount!) + " " + bill.currency
        }
        
        cell.topLabel.text = billName
        cell.middleLabel.text = payeeName
        cell.bottomLabel.text = dueDate
        cell.rightLabel.text = billAmount
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("billsToABill", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let bill = bills[indexPath.row]
        if editingStyle == .Delete
        {
            let alertController = UIAlertController(title: "Delete Bill",
                                                    message: "Are you sure you want to permanently delete \(bill.name) bill?",
                                                    preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                action in
                let deleted = DBWrapper.deleteBill(bill)
                if deleted
                {
                    self.bills.removeAtIndex(indexPath.row)
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

















