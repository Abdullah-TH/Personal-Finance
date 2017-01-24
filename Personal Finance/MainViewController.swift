//
//  MainViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/19/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    let MainScreensTitle = [["All Transactions"], ["Accounts", "Bills", "Budget"], ["Categories", "Payees"], ["Reports"], ["History"]]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = NSDate.getThisMonthAndYearAsString()
        self.navigationController!.view.backgroundColor = UIColor.whiteColor()
        
        let money: SAR = 100.2
        print("I have \(money)")
        
        Yahoo<USD,SAR>.fx(100)
        {
            sar in
            print("You got \(sar)")
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case "MainToAllTransactions":
                let transactionsVC = segue.destinationViewController as! TransactionsViewController
                transactionsVC.transactions = DBWrapper.getAllTransactionsOf(monthYearString: NSDate.getThisMonthAndYearNumberAsString())
                transactionsVC.navigationItem.title = "All Transactions"
                
            case "MainToAccounts":
                let accountsVC = segue.destinationViewController as! AccountsViewController
                accountsVC.navigationItem.title = "Accounts"
                
            case "MainToBills":
                let billsVC = segue.destinationViewController as! BillsViewController
                billsVC.navigationItem.title = "Bills"
                
            case "MainToBudget":
                let budgetVC = segue.destinationViewController as! BudgetViewController
                budgetVC.navigationItem.title = "Budgets"
                
            case "MainToCategories":
                let categoriesVC = segue.destinationViewController as! CategoriesViewController
                categoriesVC.navigationItem.title = "Categories"
                
            case "MainToPayees":
                let payeesVC = segue.destinationViewController as! PayeesViewController
                payeesVC.navigationItem.title = "Payees"
            
            case "MainToReports":
                let reportsVC = segue.destinationViewController as! ReportsViewController
                reportsVC.navigationItem.title = "Reports"
                
            case "MainToHistory":
                let historyVC = segue.destinationViewController as! HistoryViewController
                historyVC.navigationItem.title = "History"
                
            case "MainToAddTransaction":
                let nav = segue.destinationViewController as! UINavigationController
                let addTransactionVC = nav.topViewController as! AddTransactionViewController
                addTransactionVC.navigationItem.title = "New Transaction"
                
                
            default:
                break
            }
        }
        
        
        
    }
    
    
    // MARK: UITableView DataSource and Delegate methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
        case 0, 3, 4:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = MainScreensTitle[indexPath.section][indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let screen = MainScreensTitle[indexPath.section][indexPath.row]
        switch screen
        {
        case "All Transactions":
            performSegueWithIdentifier("MainToAllTransactions", sender: nil)
        case "Accounts":
            performSegueWithIdentifier("MainToAccounts", sender: nil)
        case "Bills":
            performSegueWithIdentifier("MainToBills", sender: nil)
        case "Budget":
            performSegueWithIdentifier("MainToBudget", sender: nil)
        case "Categories":
            performSegueWithIdentifier("MainToCategories", sender: nil)
        case "Payees":
            performSegueWithIdentifier("MainToPayees", sender: nil)
        case "Reports":
            performSegueWithIdentifier("MainToReports", sender: nil)
        case "History":
            performSegueWithIdentifier("MainToHistory", sender: nil)
        default:
            break
        }
    }


}












