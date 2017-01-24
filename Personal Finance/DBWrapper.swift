//
//  DBWrapper.swift
//  Personal Finance
// 
//  This class is another wrapper on top of the FMDB-wrapper particular to this application
//
//  Created by Abdullah Althobetey on 3/20/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import UIKit

class DBWrapper
{
    
    /// return an FMDatabase object of the database file 'PersonalFinance.sqlite'
    /// note that the returned FMDatabase object is not open, you need to call open() before you use it
    private static func getPersonalFinanceDB() -> FMDatabase
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docDir = paths[0] as NSString
        let dbPath = docDir.stringByAppendingPathComponent("PersonalFinance.sqlite")
        let db = FMDatabase(path: dbPath)
        
        return db
    }
    
    
    // MARK: Retrieve Data
    
    /// get all accounts data from PersonalFinance.sqlite database
    /// - returns: [Account]
    static func getAllAccounts() -> [Account]
    {
        var accounts = [Account]()
        let db = DBWrapper.getPersonalFinanceDB()
        db.open()
        
        let result = db.executeQuery("SELECT * FROM Account;", withArgumentsInArray: nil)
        while result.next()
        {
            let id = Int(result.intForColumn("id"))
            let name = result.stringForColumn("name")
            let type = AccountType(rawValue:result.stringForColumn("type"))!
            let balance = Int(result.intForColumn("balance"))
            let currency = result.stringForColumn("currency")
            
            let account = Account(id: id, name: name, type: type, balance: balance, currency: currency)
            accounts.append(account)
        }
        db.close()
        return accounts
    }
    
    
    /// get all categories from PersonalFinance.sqlite datebase
    /// - returns: [TransactionCategory]
    static func getAllCategories() -> [TransactionCategory]
    {
        return getCategoriesWithQuery("SELECT * FROM Category")
    }
    
    /// get all expense categories from PersonalFinance.sqlite datebase
    /// - returns: [TransactionCategory]
    static func getAllExpensCategories() -> [TransactionCategory]
    {
        return getCategoriesWithQuery("SELECT * FROM Category WHERE type = 'expense'")
    }
    
    /// get all income categories from PersonalFinance.sqlite datebase
    /// - returns: [TransactionCategory]
    static func getAllIncomeCategories() -> [TransactionCategory]
    {
        return getCategoriesWithQuery("SELECT * FROM Category WHERE type = 'income'")
    }
    
    
    /// get all payess from PersonalFinance.sqlite database
    /// - returns: [Payee]
    static func getAllPayees() -> [Payee]
    {
        var payees = [Payee]()
        let db = DBWrapper.getPersonalFinanceDB()
        db.open()
        
        let result = db.executeQuery("SELECT * FROM Payee;", withArgumentsInArray: nil)
        while result.next()
        {
            let id = Int(result.intForColumn("id"))
            let name = result.stringForColumn("name")
            
            let payee = Payee(id: id, name: name)
            payees.append(payee)
        }
        db.close()
        return payees
    }
    
    
    /// get all transactions from PersonalFinance.sqlite
    /// - returns: [Transaction]
    static func getAllTransactions() -> [Transaction]
    {
        return getTransactionsWithQuery("SELECT * FROM Trans;")
    }
    
    
    /// get all transactions of the specified _month_
    /// - parameter month: a String of the month number in the form MM (ex "01" or "12")
    /// - returns: [Transaction]
    static func getAllTransactionsOf(monthYearString monthYearStr: String) -> [Transaction]
    {
        return getTransactionsWithQuery("SELECT * FROM Trans WHERE strftime('%m-%Y', date) = '\(monthYearStr)';")
    }
    
    
    /// get all transactions of the specified _account_
    /// - parameter account: Account object
    /// - returns: [Transaction]
    static func getAllTransactionsOf(account account: Account) -> [Transaction]
    {
        return getTransactionsWithQuery("SELECT * FROM Trans WHERE account_id = '\(account.id!)';")
    }
    
    
    /// get all bills from PersonalFinance.sqlite database
    /// - returns: [Bill]
    static func getAllBills() -> [Bill]
    {
        var bills = [Bill]()
        let db = DBWrapper.getPersonalFinanceDB()
        db.open()
        
        let result = db.executeQuery("SELECT * FROM Bill;", withArgumentsInArray: nil)
        while result.next()
        {
            let id = Int(result.intForColumn("id"))
            let name = result.stringForColumn("name")
            let amount = Int(result.intForColumn("amount"))
            let currency = result.stringForColumn("currency")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yy-MM-dd"
            let date = dateFormatter.dateFromString(result.stringForColumn("date"))!
            
            let recurring = result.stringForColumn("recurring")
            let status = BillStatus(rawValue: result.stringForColumn("status"))!
            let payeeID = Int(result.intForColumn("payee_id"))
            
            let bill = Bill(id: id, name: name, amount: amount, currency: currency, date: date, recurring: recurring, status: status, payeeID: payeeID)
            bills.append(bill)
        }
        db.close()
        return bills
    }
    
    
    /// get all budgets from PersonalFinance.sqlite database
    /// - returns: [Budget]
    static func getAllBudgets() -> [Budget]
    {
        var budgets = [Budget]()
        let db = DBWrapper.getPersonalFinanceDB()
        db.open()
        
        let result = db.executeQuery("SELECT * FROM Budget;", withArgumentsInArray: nil)
        while result.next()
        {
            let id = Int(result.intForColumn("id"))
            let amount = Int(result.intForColumn("amount"))
            let categoryID = Int(result.intForColumn("category_id"))
            
            let budget = Budget(id: id, amount: amount, categoryID: categoryID)
            budgets.append(budget)
        }
        db.close()
        return budgets
    }
    
    /// get month and year numbers as String that have one or more transactions from the PersonalFinance.sqlite
    /// - returns: [String] with each String contain month and year number in the form "MM-yyyy" ex. "02-2016", "12-2015"
    static func getMonthsAndYearsThatHaveTransactions() -> [String]
    {
        var months = [String]()
        let db = DBWrapper.getPersonalFinanceDB()
        db.open()
        let result = db.executeQuery("SELECT DISTINCT strftime('%m-%Y', date) AS month FROM Trans;", withArgumentsInArray: nil)
        while result.next()
        {
            months.append(result.stringForColumn("month"))
        }
        
        db.close()
        return months
    }
    
    
    
    /// get transactions from the PersonalFinance.sqlite database by the specified query
    /// - parameter query: a String of the SQLite statement. The query must use SELECT on the table Trans only
    /// - returns: [Transaction]
    private static func getTransactionsWithQuery(query: String) -> [Transaction]
    {
        var transactions = [Transaction]()
        let db = DBWrapper.getPersonalFinanceDB()
        db.open()
        
        let result = db.executeQuery(query, withArgumentsInArray: nil)
        while result.next()
        {
            let id = Int(result.intForColumn("id"))
            let type = TransactionType(rawValue: result.stringForColumn("type"))!
            let amount = Int(result.intForColumn("amount"))
            let currency = result.stringForColumn("currency")
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.dateFromString(result.stringForColumn("date"))!
            
            let recurring = result.stringForColumn("recurring")
            let notes = result.stringForColumn("notes")
            let image: UIImage?
            if let imageData = result.dataForColumn("image")
            {
                image = UIImage(data: imageData)
            }
            else
            {
                image = nil
            }
            
            let accountID = Int(result.intForColumn("account_id"))
            let categoryID = Int(result.intForColumn("category_id"))
            let payeeID = Int(result.intForColumn("payee_id"))
            
            let transaction = Transaction(
                id: id,
                type: type,
                amount: amount,
                currency: currency,
                date: date,
                recurring: recurring,
                notes: notes,
                image: image,
                accountID: accountID,
                categoryID: categoryID,
                payeeID: payeeID)
            
            transactions.append(transaction)
        }
        db.close()
        return transactions
    }
    
    /// get categories from the PersonalFinance.sqlite database by the specified query
    /// - parameter query: a String of the SQLite statement. The query must use SELECT on the table Category only
    /// - returns: [TransactionCategory]
    private static func getCategoriesWithQuery(query: String) -> [TransactionCategory]
    {
        var categories = [TransactionCategory]()
        let db = DBWrapper.getPersonalFinanceDB()
        db.open()
        
        let result = db.executeQuery(query, withArgumentsInArray: nil)
        while result.next()
        {
            let id = Int(result.intForColumn("id"))
            let name = result.stringForColumn("name")
            let type = TransactionType(rawValue: result.stringForColumn("type"))!
            let iconName = result.stringForColumn("iconName")
            
            let category = TransactionCategory(id: id, name: name, type: type, iconName: iconName)
            categories.append(category)
        }
        db.close()
        return categories
    }
    
    
    // MARK: Save Data
    
    /// save the Transaction to the datebase
    /// - returns: true if the operation successed or false otherwise
    static func saveTransaction(trans: Transaction) -> Bool
    {
        // Save The Transaction
        let type = trans.type.rawValue
        let amount = trans.amount
        let currency = trans.currency
        let date = NSDate.getDateAsString(date: trans.date)
        let recurring = trans.recurring
        let notes = trans.notes
        
        var imageData: NSData?
        if let image = trans.image
        {
            imageData = UIImageJPEGRepresentation(image, CGFloat(1.0))
        }
        
        let accountID = trans.accountID
        let categoryID = trans.categoryID
        let payeeID = trans.payeeID
        
        let db = getPersonalFinanceDB()
        db.open()
        let transInserted = db.executeUpdate("INSERT INTO Trans VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            withArgumentsInArray: [type, amount, currency, date, recurring ?? NSNull(), notes ?? NSNull(), imageData ?? NSNull(), accountID, payeeID ?? NSNull(), categoryID])
        
        
        // Update Relevant Account Balance
        var accountUpdated = false
        if transInserted
        {
            let result = db.executeQuery("SELECT * FROM Account WHERE id = \(accountID)", withArgumentsInArray: nil)
            result.next()
            let currentBalance = Int(result.intForColumn("balance"))
            let newBalance = currentBalance + amount
            accountUpdated = db.executeUpdate("UPDATE Account SET balance = \(newBalance) WHERE id = \(accountID)", withArgumentsInArray: nil)
        }
        
        db.close()
        return transInserted && accountUpdated
    }
    
    
    /// save the account to the database
    static func saveAccount(account: Account) -> Bool
    {
        let name = account.name
        let type = account.type.rawValue
        let currency = account.currency
        let balance = account.balance
        
        let db = getPersonalFinanceDB()
        db.open()
        
        let accountSaved = db.executeUpdate("INSERT INTO Account VALUES (NULL, ?, ?, ?, ?)", withArgumentsInArray: [name, type, balance, currency])
        
        db.close()
        return accountSaved
    }
    
    
    /// save bill to the database
    static func saveBill(bill: Bill) -> Bool
    {
        let name = bill.name
        let amount = bill.amount
        let currency = bill.currency
        let date = NSDate.getDateAsString(date: bill.date)
        let recurring = bill.recurring!
        let status = bill.status.rawValue
        let payeeID = bill.payeeID
        
        let db = getPersonalFinanceDB()
        db.open()
        
        let billSaved = db.executeUpdate("INSERT INTO Bill VALUES (NULL, ?, ?, ?, ?, ?, ?, ?)",
                                         withArgumentsInArray: [name, amount ?? NSNull(), currency, date, recurring, status, payeeID])
        
        db.close()
        return billSaved
    }
    
    
    /// save budget to the database
    static func saveBudget(budget: Budget) -> Bool
    {
        let categoryID = budget.categoryID
        let amount = budget.amount
        
        let db = getPersonalFinanceDB()
        db.open()
        
        let budgetSaved = db.executeUpdate("INSERT INTO Budget VALUES (NULL, ?, ?)", withArgumentsInArray: [amount, categoryID])
        
        db.close()
        return budgetSaved
    }
    
    
    /// save category to the database
    static func saveCategory(category: TransactionCategory) -> Bool
    {
        let name = category.name
        let type = category.type.rawValue
        let iconName = category.iconName
        
        let db = getPersonalFinanceDB()
        db.open()
        
        let categorySaved = db.executeUpdate("INSERT INTO Category VALUES (NULL, ?, ?, ?)", withArgumentsInArray: [name, type, iconName])
        
        db.close()
        return categorySaved
    }
    
    
    /// save payee to the database
    static func savePayee(payee: Payee) -> Bool
    {
        let name = payee.name
        let db = getPersonalFinanceDB()
        db.open()
        let payeeSaved = db.executeUpdate("INSERT INTO Payee VALUES (NULL, ?)", withArgumentsInArray: [name])
        db.close()
        return payeeSaved
    }
    
    
    // MARK: Delete Data
    
    // delete transaction from the database
    static func deleteTransaction(transaction: Transaction) -> Bool
    {
        let db = getPersonalFinanceDB()
        db.open()
        let fkEnabled = db.executeStatements("PRAGMA foreign_keys = ON")
        
        let deleted = db.executeUpdate("DELETE FROM Trans WHERE id = ?", withArgumentsInArray: [transaction.id!])
        
        // update relevant account balance
        var accountUpdated = false
        if deleted
        {
            let result = db.executeQuery("SELECT * FROM Account WHERE id = \(transaction.accountID)", withArgumentsInArray: nil)
            result.next()
            let currentBalance = Int(result.intForColumn("balance"))
            let newBalance = currentBalance - transaction.amount
            accountUpdated = db.executeUpdate("UPDATE Account SET balance = \(newBalance) WHERE id = \(transaction.accountID)", withArgumentsInArray: nil)
        }
        
        db.close()
        return deleted && accountUpdated && fkEnabled
    }
    
    
    /// delete account from the database
    static func deleteAccount(account: Account) -> Bool
    {
        let db = getPersonalFinanceDB()
        db.open()
        let fkEnabled = db.executeStatements("PRAGMA foreign_keys = ON")
        
        let deleted = db.executeUpdate("DELETE FROM Account WHERE id = ?", withArgumentsInArray: [account.id!])
        
        db.close()
        return deleted && fkEnabled
    }
    
    
    /// delete bill from the database
    static func deleteBill(bill: Bill) -> Bool
    {
        let db = getPersonalFinanceDB()
        db.open()
        let fkEnabled = db.executeStatements("PRAGMA foreign_keys = ON")
        
        let deleted = db.executeUpdate("DELETE FROM Bill WHERE id = ?", withArgumentsInArray: [bill.id!])
        
        db.close()
        return deleted && fkEnabled
    }
    
    
    /// delete budget from the database
    static func deleteBudget(budget: Budget) -> Bool
    {
        let db = getPersonalFinanceDB()
        db.open()
        let fkEnabled = db.executeStatements("PRAGMA foreign_keys = ON")
        
        let deleted = db.executeUpdate("DELETE FROM Budget WHERE id = ?", withArgumentsInArray: [budget.id!])
        
        db.close()
        return deleted && fkEnabled
    }
    
    
    /// delete category from the database
    static func deleteCategory(category: TransactionCategory) -> Bool
    {
        let db = getPersonalFinanceDB()
        db.open()
        let fkEnabled = db.executeStatements("PRAGMA foreign_keys = ON")
        
        let deleted = db.executeUpdate("DELETE FROM Category WHERE id = ?", withArgumentsInArray: [category.id!])
        
        db.close()
        return deleted && fkEnabled
    }
    
    
    /// delete payee from the database
    static func deletePayee(payee: Payee) -> Bool
    {
        let db = getPersonalFinanceDB()
        db.open()
        let fkEnabled = db.executeStatements("PRAGMA foreign_keys = ON")
        
        let deleted = db.executeUpdate("DELETE FROM Payee WHERE id = ?", withArgumentsInArray: [payee.id!])
        
        db.close()
        return deleted && fkEnabled
    }
    
    
    
    
    // MARK: Update Data
    
    
    
    /// update transaction
    static func updateTransaction(transaction: Transaction) -> Bool
    {
        return false
    }
    
}

















