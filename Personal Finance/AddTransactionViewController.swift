//
//  AddTransactionViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/22/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AccountSelectionDelegate, CategorySelectionDelegate,
    CurrencySelectionDelegate, PayeeSelectionDelegate, RecurringSelectionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UITextFieldDelegate
{
    @IBOutlet weak var transactionTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var type: TransactionType? = .Expense
    var account: Account?
    var category: TransactionCategory?
    var amount: Int?
    var currency: String?
    var payee: Payee?
    var date: NSDate! // always set to current date in viewDidLoad()
    var recurring = "Never"
    var photo: UIImage?
    var notes: String?
    
    private var dateEditing = false
    private var isAddTransactionMode: Bool! // if false then the view controller is in update transaction mode

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        date = NSDate()
        
        isAddTransactionMode = presentingViewController is UINavigationController
        
        if isAddTransactionMode!
        {
            self.navigationItem.title = "New Transaction"
        }
        else
        {
            self.navigationItem.title = "Update Transaction"
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()
        
    }
    
    
    @IBAction func saveTransaction(sender: AnyObject)
    {
        if let type = type, let account = account, let category = category, var amount = amount, let currency = currency, let date = date
        {
            if type == .Expense
            {
                amount = -amount
            }
            
            let transaction = Transaction(
                id: nil,
                type: type,
                amount: amount,
                currency: currency,
                date: date,
                recurring: recurring,
                notes: notes,
                image: photo,
                accountID: account.id!,
                categoryID: category.id!,
                payeeID: payee?.id)
            
            var saved: Bool
            
            if isAddTransactionMode!
            {
                saved = DBWrapper.saveTransaction(transaction)
            }
            else
            {
                saved = DBWrapper.updateTransaction(transaction)
            }
            
            if saved
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
    
    @IBAction func cancelAddTransaction(sender: AnyObject)
    {
        if presentingViewController is UINavigationController // presented using add transaction mode
        {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else // presented using update transaction mode
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    @IBAction func dateChanged(sender: UIDatePicker)
    {
        date = sender.date
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 5, inSection: 0)], withRowAnimation: .None)
    }
    
    @IBAction func typeChanged(sender: AnyObject)
    {
        category = nil
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 1, inSection: 0)], withRowAnimation: .None)
        switch transactionTypeSegmentControl.selectedSegmentIndex
        {
        case 0:
            type = .Expense
        case 1:
            type = .Income
        default:
            break
        }
    }
    
    @IBAction func amountChanged(sender: AnyObject)
    {
        let amountCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 2, inSection: 0)) as! TextFieldTableViewCell
        amount = Int(amountCell.textField.text!)
    }
    
    func selectedAccount(account: Account)
    {
        self.account = account
    }
    
    func selectedCategory(category: TransactionCategory)
    {
        self.category = category
    }
    
    func selectedCurrency(currency: String)
    {
        self.currency = currency
    }
    
    func selectedPayee(payee: Payee)
    {
        self.payee = payee
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
            
        case "NewTransactionToAccountSelection":
            let accountSelectionVC = segue.destinationViewController as! AccountSelectionViewController
            accountSelectionVC.delegate = self
            accountSelectionVC.selectedAccount = account
            
        case "NewTransactionToCategorySelection":
            let categorySelectionVC = segue.destinationViewController as! CategorySelectionViewController
            categorySelectionVC.delegate = self
            categorySelectionVC.selectedCategory = category
            if transactionTypeSegmentControl.selectedSegmentIndex == 0
            {
                categorySelectionVC.categories = DBWrapper.getAllExpensCategories()
            }
            else if transactionTypeSegmentControl.selectedSegmentIndex == 1
            {
                categorySelectionVC.categories = DBWrapper.getAllIncomeCategories()
            }
            else
            {
                // this is the case were user select transfer operation
                // in this case just use an empty array, because transfer always uses the special category 'Transfer'
                categorySelectionVC.categories = [TransactionCategory]()
            }
            
        case "NewTransactionToCurrencySelection":
            let currencySelectionVC = segue.destinationViewController as! CurrencySelectionViewController
            currencySelectionVC.delegate = self
            currencySelectionVC.selectedCurrency = currency
            
        case "NewTransactionToPayeeSelection":
            let payeeSelectionVC = segue.destinationViewController as! PayeeSelectionViewController
            payeeSelectionVC.delegate = self
            payeeSelectionVC.selectedPayee = payee
            
        case "NewTransactionToRecurringSelection":
            let recurringSelectionVC = segue.destinationViewController as! RecurringSelectionViewController
            recurringSelectionVC.delegate = self
            recurringSelectionVC.selectedRecurring = recurring
            
            
        default:
            break
        }
    }
    

    // MARK: UITableViewDataSource and UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0
        {
            return CGFloat.min
        }
        
        return tableView.sectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        switch indexPath.row
        {
        case 8: // photo row
            return CGFloat(54)
        
        case 9: // notes row
            return CGFloat(120)
        
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
        case 0: // Account Selection
            let selectionCell = UITableViewCell(style: .Value1, reuseIdentifier: "SelectionCell")
            selectionCell.accessoryType = .DisclosureIndicator
            selectionCell.textLabel?.text = "Account"
            selectionCell.detailTextLabel?.text = account?.name ?? "Select Account"
            return selectionCell
            
        case 1: // Category Selection
            let selectionCell = UITableViewCell(style: .Value1, reuseIdentifier: "SelectionCell")
            selectionCell.accessoryType = .DisclosureIndicator
            selectionCell.textLabel?.text = "Category"
            selectionCell.detailTextLabel?.text = category?.name ?? "Select Category"
            return selectionCell
            
        case 2: // Amount Field
            let fieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldTableViewCell
            fieldCell.textField.placeholder = "Amount"
            if let amount = amount { fieldCell.textField.text = String(amount) }
            return fieldCell
            
        case 3: // Currency Selection
            let selectionCell = UITableViewCell(style: .Value1, reuseIdentifier: "SelectionCell")
            selectionCell.accessoryType = .DisclosureIndicator
            selectionCell.textLabel?.text = "Currency"
            selectionCell.detailTextLabel?.text = currency ?? "Select Currency"
            return selectionCell
            
        case 4: // Payee Selection
            let selectionCell = UITableViewCell(style: .Value1, reuseIdentifier: "SelectionCell")
            selectionCell.accessoryType = .DisclosureIndicator
            selectionCell.textLabel?.text = "Payee"
            selectionCell.detailTextLabel?.text = payee?.name ?? "None"
            return selectionCell
            
        case 5: // Date Selection
            let selectionCell = UITableViewCell(style: .Value1, reuseIdentifier: "SelectionCell")
            selectionCell.accessoryType = .DisclosureIndicator
            selectionCell.textLabel?.text = "Date"
            selectionCell.detailTextLabel?.text = NSDate.getDateAsString(date: date)
            selectionCell.accessoryType = .None
            return selectionCell
            
        case 6: // Date Picker
            let datePickerCell = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as! DatePickerTableViewCell
            return datePickerCell
            
        case 7: // Recurring Selection
            let selectionCell = UITableViewCell(style: .Value1, reuseIdentifier: "SelectionCell")
            selectionCell.accessoryType = .DisclosureIndicator
            selectionCell.textLabel?.text = "Recurring"
            selectionCell.detailTextLabel?.text = recurring
            selectionCell.accessoryType = .None
            return selectionCell
            
        case 8: // Image Selection
            let photoCell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! photoTableViewCell
            photoCell.leftLabel.text = "Photo"
            if let photo = photo { photoCell.photoView.image =  photo}
            return photoCell
            
        case 9: // Notes Field
            let textViewCell = tableView.dequeueReusableCellWithIdentifier("TextViewCell") as! textViewTableViewCell
            textViewCell.textView.text = "Notes"
            return textViewCell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row
        {
        case 0:
            performSegueWithIdentifier("NewTransactionToAccountSelection", sender: nil)
        case 1:
            performSegueWithIdentifier("NewTransactionToCategorySelection", sender: nil)
        case 3:
            performSegueWithIdentifier("NewTransactionToCurrencySelection", sender: nil)
        case 4:
            performSegueWithIdentifier("NewTransactionToPayeeSelection", sender: nil)
        case 5:
            dateEditing = !dateEditing
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 6, inSection: 0)], withRowAnimation: .Fade)
        case 7:
            performSegueWithIdentifier("NewTransactionToRecurringSelection", sender: nil)
        case 8:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
            
        default:
            break
        }
        
    }
    
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photo = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }
    
    

}


























