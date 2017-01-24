//
//  NewBillViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/27/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class NewBillViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PayeeSelectionDelegate, CurrencySelectionDelegate,
    RecurringSelectionDelegate
{
    @IBOutlet weak var tableView: UITableView!

    var billName: String?
    var payee: Payee?
    var amount: Int?
    var currency: String?
    var startDate = NSDate()
    var recurring = "Monthly"
    
    var amountIsFixed = false
    var dateEditing = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

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
    
    @IBAction func saveBill(sender: AnyObject)
    {
        if let billName = billName, payee = payee, currency = currency
        {
            let newBill = Bill(
                id: nil,
                name: billName,
                amount: amount,
                currency: currency,
                date: startDate,
                recurring: recurring,
                status: .NotPaid,
                payeeID: payee.id!)
            
            if DBWrapper.saveBill(newBill)
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
    
    @IBAction func amountOrNameChanged(sender: AnyObject)
    {
        let nameCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TextFieldTableViewCell
        let amountCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! TextFieldTableViewCell
        billName = nameCell.textField.text
        amount = Int(amountCell.textField.text!)
    }
    
    @IBAction func amountVariesOrFixed(sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex
        {
        case 0:
            amountIsFixed = false
            amount = nil
        case 1:
            amountIsFixed = true
            let amountCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! TextFieldTableViewCell
            amount = Int(amountCell.textField.text!)
        default:
            break
        }
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Fade)
    }
    
    @IBAction func dateChanged(sender: UIDatePicker)
    {
        startDate = sender.date
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 5, inSection: 0)], withRowAnimation: .None)
    }
    
    func selectedPayee(payee: Payee)
    {
        self.payee = payee
    }
    
    func selectedCurrency(currency: String)
    {
        self.currency = currency
    }
    
    func selectedRecurring(recurring: String)
    {
        self.recurring = recurring
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        switch segue.identifier!
        {
        case "NewBillToPayeeSelection":
            let payeeSelectionVC = segue.destinationViewController as! PayeeSelectionViewController
            payeeSelectionVC.delegate = self
            payeeSelectionVC.selectedPayee = payee
            
        case "NewBillToCurrencySelection":
            let currencySelectionVC = segue.destinationViewController as! CurrencySelectionViewController
            currencySelectionVC.delegate = self
            currencySelectionVC.selectedCurrency = currency
            
        case "NewBillToRecurringSelection":
            let recurringSelectionVC = segue.destinationViewController as! RecurringSelectionViewController
            recurringSelectionVC.delegate = self
            recurringSelectionVC.selectedRecurring = recurring
            recurringSelectionVC.recurrings.removeFirst() // remove 'Never' because bills must have recurring specified
            
            
        default:
            break
        }
    }
    
    
    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.row
        {
        case 3: // amount row
            if amountIsFixed
            {
                return tableView.rowHeight
            }
            else
            {
                return CGFloat(0)
            }
        case 6: // date picker row
            if dateEditing
            {
                return CGFloat(208)
            }
            else
            {
                return CGFloat(0)
            }
            
        default:
            return tableView.rowHeight
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
        case 0: // name field
            let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldTableViewCell
            cell.textField.placeholder = "Name"
            return cell
            
        case 1: // payee selection
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Payee"
            cell.detailTextLabel?.text = payee?.name ?? "Select Payee"
            return cell
            
        case 2: // amount varies or fixed selection
            let cell = tableView.dequeueReusableCellWithIdentifier("segmentedControllCell") as! SegmentadControlTableViewCell
            cell.leftLabel.text = "Amount"
            cell.segmentedControl.setTitle("Varies", forSegmentAtIndex: 0)
            cell.segmentedControl.setTitle("Fixed", forSegmentAtIndex: 1)
            return cell
            
        case 3: // amount field
            let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldTableViewCell
            cell.textField.placeholder = "Amount"
            cell.textField.keyboardType = .NumberPad
            return cell
            
        case 4: // currency selection
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Currency"
            cell.detailTextLabel?.text = currency ?? "Select Currency"
            return cell
            
        case 5: // date selection
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "SelectionCell")
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Start Date"
            cell.detailTextLabel?.text = NSDate.getDateAsString(date: startDate)
            cell.accessoryType = .None
            return cell
            
        case 6: // Date Picker
            let datePickerCell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerTableViewCell
            datePickerCell.datePicker.maximumDate = nil
            return datePickerCell
            
        case 7: // recurring selection
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = "Recurring"
            cell.detailTextLabel?.text = recurring
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
            performSegueWithIdentifier("NewBillToPayeeSelection", sender: nil)
        case 4:
            performSegueWithIdentifier("NewBillToCurrencySelection", sender: nil)
        case 5:
            dateEditing = !dateEditing
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 6, inSection: 0)], withRowAnimation: .Fade)
        case 7:
            performSegueWithIdentifier("NewBillToRecurringSelection", sender: nil)
            
        default:
            break
        }
    }
    

    

}




























