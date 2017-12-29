//
//  ViewController.swift
//   JSON
//
//  Created by Rafael M. Trasmontero on 12/28/17.
//  Copyright © 2017 KLTuts. All rights reserved.
//
//Objective: Use "jsonplaceholder.typicode.com" to try to GET Data and to POST data

import UIKit

class ViewController: UIViewController {
    
    
    @IBAction func onGetTapped(_ sender: Any) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            if let theResponse = response {
                print(theResponse)
            }
            
            if let theData = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: theData, options: [])
                    print(json)
                } catch {
                    print(error)
                }
                
            }
            }.resume()
    }
    
    //Note: Theres 2 types of "JSONSerialization.data" in POSTing. "writingOption" & "readingOption"
    
    @IBAction func onPostTapped(_ sender: Any) {
        
        //POST IT
        let parameters = ["username": "@TESTUserName", "tweet": "TESTHelloWorld"]
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //<--letsAPI know we're sending json
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        //SEE IF POSTED
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        
    }
    
    
}


