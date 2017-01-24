//
//  NewAccountViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/25/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CurrencySelectionDelegate, AccountTypeSelectionDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    var nameTextField: UITextField! // assinged in cellForRow:atIndexPath:
    var balanceTextField: UITextField! // assinged in cellForRow:atIndexPath:
    
    var accountName: String?
    var type: AccountType?
    var currency: String?
    var balance: Int?

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
    
    @IBAction func nameOrBalanceChanged(sender: AnyObject)
    {
        accountName = nameTextField.text
        balance = Int(balanceTextField.text!)
    }
    
    @IBAction func cancel(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAccount(sender: AnyObject)
    {
        if let accountName = accountName, type = type, currency = currency, balance = balance
        {
            let newAccount = Account(id: nil, name: accountName, type: type, balance: balance, currency: currency)
            
            if DBWrapper.saveAccount(newAccount)
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
    
    func selectedCurrency(currency: String)
    {
        self.currency = currency
    }
    
    func selectedType(type: AccountType)
    {
        self.type = type
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        switch segue.identifier!
        {
        case "NewAccountToCurrencySelection":
            let currencySelectionVC = segue.destinationViewController as! CurrencySelectionViewController
            currencySelectionVC.delegate = self
            currencySelectionVC.selectedCurrency = currency
            
        case "NewAccountToTypeSelection":
            let typeSelectionVC = segue.destinationViewController as! AccountTypeSelectionViewController
            typeSelectionVC.delegate = self
            typeSelectionVC.selectedType = type
            
        default:
            break
        }
    }
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
        case 0: // account name
            let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldTableViewCell
            cell.textField.placeholder = "Account Name"
            nameTextField = cell.textField
            return cell
            
        case 1: // account type
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.textLabel?.text = "Type"
            cell.detailTextLabel?.text = type?.rawValue ?? "Select Type"
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        case 2: // account currency
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.textLabel?.text = "Currency"
            cell.detailTextLabel?.text = currency ?? "Select Currency"
            cell.accessoryType = .DisclosureIndicator
            return cell
            
        case 3: // balance
            let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldTableViewCell
            cell.textField.placeholder = "Start Balance"
            cell.textField.keyboardType = .NumberPad
            balanceTextField = cell.textField
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row
        {
        case 1:
            performSegueWithIdentifier("NewAccountToTypeSelection", sender: nil)
        case 2:
            performSegueWithIdentifier("NewAccountToCurrencySelection", sender: nil)
            
        default:
            break
        }
    }
    
    

}



























