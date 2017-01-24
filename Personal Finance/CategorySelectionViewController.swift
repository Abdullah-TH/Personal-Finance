//
//  CategorySelectionViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/23/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

protocol CategorySelectionDelegate
{
    func selectedCategory(category: TransactionCategory)
}

class CategorySelectionViewController: UIViewController
{
    var delegate: CategorySelectionDelegate?
    
    var categories: [TransactionCategory]!
    var selectedCategory: TransactionCategory?

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.imageView?.image = UIImage(named: category.iconName) 
        
        if let selectedCategory = selectedCategory
        {
            if selectedCategory.id == category.id
            {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        let selectedCategory = categories[(tableView.indexPathForSelectedRow?.row)!]
        delegate?.selectedCategory(selectedCategory)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }

}
