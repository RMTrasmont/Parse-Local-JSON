//
//  ViewController.swift
//  Callbacks And Threading
//
//  Created by Rafael M. Trasmontero on 12/28/17.
//  Copyright © 2017 KLTuts. All rights reserved.
//

//Objective: Get JSON Data from a local File & Display the names only on the TableView

import UIKit

class ViewController: UIViewController {
    
    var userNamesArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.dataSource = self <-- set in Storyboard
        
        //2.
        getUsers { (success, response, error) in
            if success {
                print("GET USERS BLOCK CALLED")
                guard let names = response as? [String] else { return }
                self.userNamesArray = names
                self.tableView.reloadData()
                print("RELOAD CALLED")
            } else if let error = error {
                print(error)
            }
        }
        
    }
    
    //1.    //note:use "@escaping" for Storage & Async Executions..anything tha "Throws"
    
    func getUsers(completion: @escaping (Bool, Any?, Error?) -> Void) {
        print("GET USERS FUNCTION")
        
        //*Run on Background
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            print("DISPATCH FINISHED")
            
            guard let path = Bundle.main.path(forResource: "someJSON", ofType: "txt") else { return }
            let url = URL(fileURLWithPath: path)
            
            do {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let arrayOfDict = json as? [[String: Any]] else { return }
                var names = [String]()
                for user in arrayOfDict {
                    guard let name = user["name"] as? String else { continue }
                    names.append(name)
                }
                //*Bring to Main thread
                DispatchQueue.main.async {
                    completion(true, names, nil)
                }
                //print(names)
            } catch {
                print(error)
                //*Bring to Main thread
                DispatchQueue.main.async {
                    completion(false, nil, error)
                }
            }
        }
        
    }
    
    
    
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = userNamesArray[indexPath.row]
        return cell
    }
}
