//
//  QuoteTableViewController.swift
//  BreatheInspo
//
//  Created by Elina Lua Ming on 7/30/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    let productID = "com.elinaluaming.BreatheInspo.PremiumQuotes"
    
    var quotesToShow = [
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "I breathe inspiration, but I run on discipline. – Elina Lua Ming",
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Because there is nothing more beautiful, than the ocean refuses to stop kissing the shoreline, no matter how many times it's sent away. – Sarah Kay",
        "Facts have a tendency to obscure the truth. - Amos Oz"
    ]
    
    let premiumQuotes = [
        "Faith is probably one of the most exquisite thing in the world. Albeit one must experience the view from within and without the circumference to fully comprehend it's beauty. If you're born within the girth, try stepping out, I guarantee you the view is life-changing; if you're born without the circle, try stepping in, I assure you that loneliness will be non-existent. I've learnt that sitting on the fence won't provide you with a great view of religion. Perhaps, one day I'll assemble sufficient courage to ardently embrace faith again. For now, I'd like to see what's outside the circle. ― Elina Lua Ming",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "Being sociable is a skill;being social is a choice. – Elina Lua Ming",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "I could imagine his sorrow. My father had a sensual relationship with his books. He loved feeling them, stroking them, sniffing them. He took a physical pleasure in books: he could not stop himself, he had to reach out and touch them, even other people's books. And books then really were sexier than books today: they were good to sniff and stroke and fondle. There were books with gold writing on fragrant, slightly rough leather bindings, that gave you gooseflesh when you touched them, as though you were groping something private and inaccessible, something that seemed to tremble at your touch. And there were other books that were bound in cloth-covered cardboard, stuck with a glue that had a wonderful smell. Every book had its own private, provocative scent. Sometimes the cloth came away from the cardboard, like a saucy skirt, and it was hard to resist the temptation to peep into the dark space between body and clothing and sniff those dizzying smells. – Amoz Oz"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        if isPurchased() {
            showPremiumQuotes()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count
        }
        return quotesToShow.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get more quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.6292289495, green: 0.4494991899, blue: 0.7234753966, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
    }
    
    func showPremiumQuotes() {
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }

    
    func buyPremiumQuotes() {
        
        if SKPaymentQueue.canMakePayments() {
            
            print("User can make payments")
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            
            print("User cannot make payments")
            
        }
        
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus {
            return true
        } else {
            return false
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                
                print("Payment successful")
                showPremiumQuotes()
                UserDefaults.standard.set(true, forKey: productID)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .failed {
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Payment unsuccessful due to : \(errorDescription)")
                }
                
            }
        }
        
    }
    

}
