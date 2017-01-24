//
//  PayeesViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/27/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class PayeesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var payees: [Payee]!

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
   
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return payees.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("payeeCell")
        if cell == nil
        {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "payeeCell")
        }
        
        let payee = payees[indexPath.row]
        
        cell?.accessoryType = .DisclosureIndicator
        cell?.textLabel?.text = payee.name
        
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let payee = payees[indexPath.row]
        if editingStyle == .Delete
        {
            let alertController = UIAlertController(title: "Delete Bill",
                                                    message: "Are you sure you want to permanently delete \(payee.name) bill?",
                                                    preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                action in
                let deleted = DBWrapper.deletePayee(payee)
                if deleted
                {
                    self.payees.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
                else
                {
                    let alertController = UIAlertController(title: "Error",
                        message: "You cannot delete payee that have associated bills, you must delete those bills first.",
                        preferredStyle: .Alert)
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
































