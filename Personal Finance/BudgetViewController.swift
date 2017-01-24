//
//  BudgetViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/21/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var budgets: [Budget]!
    var categories: [TransactionCategory]!
    var transactions: [Transaction]!
    
    @IBOutlet weak var monthNameOveralBudgetLabel: UILabel!
    @IBOutlet weak var amountMonthOveralBudgetLabel: UILabel!
    @IBOutlet weak var amountLeftMonthOveralBudgetLabel: UILabel!
    @IBOutlet weak var monthOveralProgress: UIProgressView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        monthOveralProgress.transform = CGAffineTransformScale(monthOveralProgress.transform, 1, 3)
        monthOveralProgress.trackTintColor = UIColor.lightGrayColor()
        
        budgets = DBWrapper.getAllBudgets()
        categories = DBWrapper.getAllCategories()
        transactions = DBWrapper.getAllTransactionsOf(monthYearString: NSDate.getThisMonthAndYearNumberAsString())
        
        // Note that expenses are stored as negative values
        let allBudgetsAmount = getTotalAmountOfBudgets()
        let amountOfAllExpensesOfBudgetedCategories = getTotalAmountOfThisMonthExpenseTransactionsOfAllBudgetedCategories()
        let amountLeftOfAllBudgets = allBudgetsAmount + amountOfAllExpensesOfBudgetedCategories
        let progressValue = Float(abs(amountOfAllExpensesOfBudgetedCategories)) / Float(allBudgetsAmount)
        
        monthNameOveralBudgetLabel.text = NSDate.getThisMonthAndYearAsString()
        amountMonthOveralBudgetLabel.text = String(allBudgetsAmount)
        amountLeftMonthOveralBudgetLabel.text = "Left: " + String(amountLeftOfAllBudgets)
        monthOveralProgress.progress = progressValue
        if progressValue >= 0.75
        {
            monthOveralProgress.tintColor = UIColor.redColor()
        }
        else if progressValue >= 0.5
        {
            monthOveralProgress.tintColor = UIColor.orangeColor()
        }
        else
        {
            monthOveralProgress.tintColor = UIColor.greenColor()
        }
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
    
    
    private func getTotalAmountOfThisMonthExpenseTransactionsOf(categoryID categoryID: Int) -> Int
    {
        var total = 0
        for transaction in transactions
        {
            if transaction.categoryID == categoryID && transaction.type == .Expense
            {
                total += transaction.amount
            }
        }
        return total
    }
    
    private func getTotalAmountOfThisMonthExpenseTransactionsOfAllBudgetedCategories() -> Int
    {
        var budgetedCategories = [TransactionCategory]()
        var total = 0
        
        for budget in budgets
        {
            for category in categories
            {
                if budget.categoryID == category.id
                {
                    budgetedCategories.append(category)
                }
            }
        }
        
        for budgetedCategory in budgetedCategories
        {
            total += getTotalAmountOfThisMonthExpenseTransactionsOf(categoryID: budgetedCategory.id!)
        }
        
        return total
    }
    
    private func getTotalAmountOfBudgets() -> Int
    {
        var total = 0
        for budget in budgets
        {
            total += budget.amount
        }
        
        return total
    }
    
    
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return budgets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryBudgetCell") as! CategoryBudgetTableViewCell
        //cell.accessoryType = .DisclosureIndicator
        
        let budget = budgets[indexPath.row]
        
        var categoryName = ""
        for category in categories
        {
            if category.id == budget.categoryID
            {
                categoryName = category.name
            }
        }
        
        let transTotal = getTotalAmountOfThisMonthExpenseTransactionsOf(categoryID: budget.categoryID)
        let amount = budget.amount
        let amountLeft = amount + transTotal
        
        cell.categoryLabel.text = categoryName
        cell.amountLabel.text = String(amount)
        cell.amountLeftLabel.text = "Left: " + String(amountLeft)
        
        let progressValue = Float(abs(transTotal)) / Float(amount)
        
        cell.progress.progress = progressValue
        if progressValue >= 0.75
        {
            cell.progress.tintColor = UIColor.redColor()
        }
        else if progressValue >= 0.5
        {
            cell.progress.tintColor = UIColor.orangeColor()
        }
        else
        {
            cell.progress.tintColor = UIColor.greenColor()
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryBudgetCell")!
        return cell.bounds.size.height
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        let budget = budgets[indexPath.row]
        var categoryName: String!
        for category in categories
        {
            if category.id == budget.categoryID
            {
                categoryName = category.name
            }
        }
        if editingStyle == .Delete
        {
            let alertController = UIAlertController(title: "Delete Budget",
                                                    message: "Are you sure you want to permanently delete \(categoryName ?? "this") budget?",
                                                    preferredStyle: .ActionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                action in
                let deleted = DBWrapper.deleteBudget(budget)
                if deleted
                {
                    self.budgets.removeAtIndex(indexPath.row)
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























