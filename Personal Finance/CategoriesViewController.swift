//
//  CategoriesViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/27/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var expenseCategories: [TransactionCategory]!
    var incomeCategories: [TransactionCategory]!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        expenseCategories = DBWrapper.getAllExpensCategories()
        incomeCategories = DBWrapper.getAllIncomeCategories()
        
        
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
    
    @IBAction func segmentedControlChanged(sender: AnyObject)
    {
        tableView.reloadData()
    }

    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if segmentedControl.selectedSegmentIndex == 0
        {
            return expenseCategories.count
        }
        else
        {
            return incomeCategories.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("categoryCell")
        if cell == nil
        {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "categoryCell")
        }
        
        let category: TransactionCategory
        if segmentedControl.selectedSegmentIndex == 0
        {
            category = expenseCategories[indexPath.row]
        }
        else
        {
            category = incomeCategories[indexPath.row]
        }
        
        cell?.accessoryType = .DisclosureIndicator
        cell?.imageView?.image = UIImage(named: category.iconName)
        cell?.textLabel?.text = category.name
        return cell!
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let category: TransactionCategory
        if segmentedControl.selectedSegmentIndex == 0
        {
            category = expenseCategories[indexPath.row]
        }
        else
        {
            category = incomeCategories[indexPath.row]
        }
        
        if editingStyle == .Delete
        {
            let alertController = UIAlertController(title: "Delete Category",
                                                    message: "Are you sure you want to permanently delete \(category.name) Category?\n" +
                                                    "This will also delete all transactions of this category.",
                                                    preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                action in
                let deleted = DBWrapper.deleteCategory(category)
                if deleted
                {
                    if self.segmentedControl.selectedSegmentIndex == 0
                    {
                        self.expenseCategories.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                    else
                    {
                        self.incomeCategories.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                }
                else
                {
                    let alertController = UIAlertController(title: "Error",
                        message: "You cannot delete category that have transactions. You must delete those transactions first.",
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














