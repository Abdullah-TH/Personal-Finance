//
//  HistoryViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/21/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var months: [String]!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        months = DBWrapper.getMonthsAndYearsThatHaveTransactions()
        if months.count > 0
        {
            months.removeLast() // the last month is the same as the current month, no need to include it in history
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getMonthNumber(monthAndYearString: String) -> String
    {
        let monthNumber = monthAndYearString.substringToIndex(monthAndYearString.startIndex.advancedBy(2))
        return monthNumber
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "HistoryToTransactions"
        {
            let month = sender as! String
            let transactionsVC = segue.destinationViewController as! TransactionsViewController
            transactionsVC.transactions = DBWrapper.getAllTransactionsOf(monthYearString: month)
            transactionsVC.navigationItem.title = NSDate.getMonthAndYearStringFromStringNumber(month)
        }
    }
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return months.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "HistoryCell")
        cell.accessoryType = .DisclosureIndicator
        let monthAndYear = NSDate.getMonthAndYearStringFromStringNumber(months[indexPath.row])
        cell.textLabel?.text = monthAndYear
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("HistoryToTransactions", sender: months[indexPath.row])
    }
    


}
























