//
//  NewPayeeViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/28/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class NewPayeeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var name: String?

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
    
    @IBAction func nameChanged(sender: UITextField)
    {
        name = sender.text
    }
    
    @IBAction func cancel(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePayee(sender: AnyObject)
    {
        if let name = name
        {
            let newPayee = Payee(id: nil, name: name)
            
            if DBWrapper.savePayee(newPayee)
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
    

    // MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! TextFieldTableViewCell
        cell.textField.placeholder = "Payee Name"
        return cell
    }
    

}
