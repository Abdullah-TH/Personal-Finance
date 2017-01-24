//
//  NewCategoryViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/28/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IconSelectionProtocol
{
    @IBOutlet weak var tableView: UITableView!
    
    var name: String?
    var type: String = "expense"
    var iconName: String?

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
    
    @IBAction func saveCategory(sender: AnyObject)
    {
        if let name = name, iconName = iconName
        {
            let newCategory = TransactionCategory(id: nil, name: name, type: TransactionType(rawValue: type)!, iconName: iconName)
            if DBWrapper.saveCategory(newCategory)
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
    
    @IBAction func nameChanged(sender: UITextField)
    {
        name = sender.text
    }
    
    @IBAction func typeChanged(sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            type = "expense"
        }
        else if sender.selectedSegmentIndex == 1
        {
            type = "income"
        }
    }
    
    func selectedIconName(iconName: String)
    {
        self.iconName = iconName
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "NewCategoryToIconSelection"
        {
            let iconSelectionVC = segue.destinationViewController as! IconSelectionViewController
            iconSelectionVC.delegate = self
        }
    }
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 2
        {
            return CGFloat(54)
        }
        return tableView.rowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
        case 0: // name field
            let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldTableViewCell
            cell.textField.placeholder = "Category Name"
            return cell
            
        case 1: // expense or income selection
            let cell = tableView.dequeueReusableCellWithIdentifier("SegmentedControlCell") as! SegmentadControlTableViewCell!
            cell.segmentedControl.setTitle("Expense", forSegmentAtIndex: 0)
            cell.segmentedControl.setTitle("Income", forSegmentAtIndex: 1)
            cell.leftLabel.text = "Type"
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! photoTableViewCell
            cell.accessoryType = .DisclosureIndicator
            cell.leftLabel.text = "Icon"
            if let iconName = iconName { cell.photoView.image = UIImage(named: iconName) }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == 2
        {
            performSegueWithIdentifier("NewCategoryToIconSelection", sender: nil)
        }
    }

}












