//
//  Model.swift
//  Personal Finance
//
//  All data models of this application
//
//  Created by Abdullah Althobetey on 3/20/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

enum TransactionType: String
{
    case Expense = "expense"
    case Income = "income"
}

enum AccountType: String
{
    case Cash = "Cash"
    case Checking = "Checking"
    case Debit = "Debit"
    case Credit = "Credit"
    case CreditCard = "Credit Card"
    case Saving = "Saving"
}

enum BillStatus: String
{
    case Paid = "paid"
    case NotPaid = "not paid"
}

struct Transaction
{
    let id: Int?
    var type: TransactionType
    var amount: Int
    var currency: String
    var date: NSDate
    var recurring: String?
    var notes: String?
    var image: UIImage?
    var accountID: Int
    var categoryID: Int
    var payeeID: Int?
}

struct Transfer
{
    let id: Int
    var amount: Int
    var currency: String
    var date: NSDate
    var recurring: String?
    var notes: String?
    var image: UIImage?
    var fromAccount: Account
    var toAccount: Account
}

struct Account
{
    let id: Int?
    var name: String
    var type: AccountType
    var balance: Int
    var currency: String
}

struct Bill
{
    let id: Int?
    var name: String
    var amount: Int?
    var currency: String
    var date: NSDate
    var recurring: String?
    var status: BillStatus
    var payeeID: Int
}

struct Budget
{
    let id: Int?
    var amount: Int
    var categoryID: Int
}

struct TransactionCategory
{
    let id: Int?
    var name: String
    var type: TransactionType
    var iconName: String
}

struct Payee
{
    let id: Int?
    var name: String
}























