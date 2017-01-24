//
//  ABillViewController.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 4/6/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class ABillViewController: UIViewController
{
    @IBOutlet weak var billNameLabel: UILabel!
    @IBOutlet weak var payeeNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recurringLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var bill: Bill!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = bill.name

        billNameLabel.text = bill.name
        
        let payees = DBWrapper.getAllPayees()
        for payee in payees
        {
            if payee.id == bill.payeeID
            {
                payeeNameLabel.text = payee.name
            }
        }
        
        amountLabel.text = "\(bill.amount) \(bill.currency)"
        dateLabel.text = NSDate.getDateAsString(date: bill.date)
        recurringLabel.text = bill.recurring
        statusLabel.text = bill.status.rawValue
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pay(sender: AnyObject)
    {
        
    }
    
    @IBAction func skip(sender: AnyObject)
    {
        
    }
    

}
