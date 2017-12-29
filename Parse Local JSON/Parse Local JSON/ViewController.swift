//
//  ViewController.swift
//  Parse Local JSON
//
//  Created by Rafael M. Trasmontero on 12/28/17.
//  Copyright © 2017 KLTuts. All rights reserved.
//

//Objective: Get JSON Data from Local File and print some of the user values, but not all

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //*GET INFO FROM "usersAPI.txt" LOCAL FILE
        
        //Path: If you are displaying an image on your website. Refer to it using "PATH" since it will be related to your current url and domain.
        
        //Url: If you are want to send it through an api to a 3rd party application, add it to an outbound email from your application or other similar scenarious, you should use the "URL" method.
        
        guard let path = Bundle.main.path(forResource: "usersAPI", ofType: "txt") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //print(json)
            
            guard let usersArray = json as? [Any] else { return }
            
            for user in usersArray {
                
                guard let userDict = user as? [String: Any] else { return }
                
                guard let userId = userDict["id"] as? Int else { print("not an Int"); return }
                guard let name = userDict["name"] as? String else { return }
                guard let company = userDict["company"] as? [String: String] else { return }
                guard let companyName = company["name"] else { return }
                
                //print(userDict)
                print(userId)
                print(name)
                print(companyName)
                print()
            }
        }
        catch {
            print(error)
        }
        
    }
    



}

