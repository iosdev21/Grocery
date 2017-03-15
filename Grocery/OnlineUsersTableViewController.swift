//
//  OnlineUsersTableViewController.swift
//  Grocery
//
//  Created by Admin on 3/14/17.
//  Copyright © 2017 harry. All rights reserved.
//

import UIKit
import FirebaseDatabase

class OnlineUsersTableViewController: UITableViewController {

    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    
    // MARK: Constants
    let userCell = "UserCell"
    
    // MARK: Properties
    var currentUsers: [String] = []
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        usersRef.observe(.childAdded, with: { snap in
            // 2
            guard let email = snap.value as? String else { return }
            self.currentUsers.append(email)
            // 3
            let row = self.currentUsers.count - 1
            // 4
            let indexPath = IndexPath(row: row, section: 0)
            // 5
            self.tableView.insertRows(at: [indexPath], with: .top)
        })
        
        usersRef.observe(.childRemoved, with: { snap in
            guard let emailToFind = snap.value as? String else { return }
            for (index, email) in self.currentUsers.enumerated() {
                if email == emailToFind {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.currentUsers.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })
    }
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
