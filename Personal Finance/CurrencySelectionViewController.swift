//
//  CurrencySelectionViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/23/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

protocol CurrencySelectionDelegate
{
    func selectedCurrency(currency: String)
}

class CurrencySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var delegate: CurrencySelectionDelegate?
    
    var currencies = ["SAR", "USD", "ADH", "GBU"]
    var selectedCurrency: String?

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currencies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        let currency = currencies[indexPath.row]
        cell.textLabel?.text = currency
        
        if let selectedCurrency = selectedCurrency
        {
            if selectedCurrency == currency
            {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        let selectedCurrency = currencies[(tableView.indexPathForSelectedRow?.row)!]
        delegate?.selectedCurrency(selectedCurrency)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
    


}
