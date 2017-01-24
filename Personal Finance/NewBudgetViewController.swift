//
//  NewBudgetViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/27/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class NewBudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CategorySelectionDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var category: TransactionCategory?
    var amount: Int?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveBudget(sender: AnyObject)
    {
        if let amount = amount, category = category
        {
            let newBudget = Budget(id: nil, amount: amount, categoryID: category.id!)
            
            if DBWrapper.saveBudget(newBudget)
            {
                dismissViewControllerAnimated(true, completion: nil)
            }
            else
            {
                let alertController = UIAlertController(title: "Error", message: "unkown error", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "ok", style: .Cancel, handler: nil))
                presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Please complete the information", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "ok", style: .Cancel, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func amountChanged(sender: UITextField)
    {
        amount = Int(sender.text!)
    }
    
    
    func selectedCategory(category: TransactionCategory)
    {
        self.category = category
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "NewBudgetToCategorySelection"
        {
            let categorySelectionVC = segue.destinationViewController as! CategorySelectionViewController
            categorySelectionVC.categories = DBWrapper.getAllExpensCategories()
            categorySelectionVC.delegate = self
            categorySelectionVC.selectedCategory = category
        }
    }
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
        case 0: // category selection
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Category"
            cell.detailTextLabel?.text = category?.name ?? "Select Category"
            return cell
            
        case 1: // amount field
            let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldTableViewCell
            cell.textField.placeholder = "Amount"
            cell.textField.keyboardType = .NumberPad
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row
        {
        case 0:
            performSegueWithIdentifier("NewBudgetToCategorySelection", sender: nil)
        default:
            break
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}
