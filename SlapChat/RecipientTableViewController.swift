//
//  RecipientTableViewController.swift
//  SlapChat
//
//  Created by Benjamin Su on 11/9/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class RecipientTableViewController: UITableViewController {

    let store = DataStore.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.generateTestData()
        store.fetchData()
        tableView.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return store.recipients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipientCell", for: indexPath)
        
        cell.textLabel?.text = store.recipients[indexPath.row].name
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MessageTableViewController,
            let index = self.tableView.indexPathForSelectedRow {
            
            dest.selectedRecipient = store.recipients[index.row]
            
        }
        
    }
    
    
}
