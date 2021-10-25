//
//  ViewController.swift
//  PostGetRequest
//
//  Created by Никита Иващенков on 25/10/2021.
//  Copyright © 2021 Никита Иващенков. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func getRequest(_ sender: Any) {
    
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
            else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard
                let response = response,
                let data = data
                else { return }
            
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data,
                                                    options: [])
                print(json)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    @IBAction func postRequest(_ sender: Any) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
            else { return }
        
        let userData = [
            "Course": "Networking",
            "Lesson": "GET and POST Requests"
        ]
        
        // request body
        var request = URLRequest(url: url)
        // request type
        request.httpMethod = "POST"
        
        // create json format
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData,
                                                         options: []) else { return }
        
        // add json data in request body
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard
                let response = response,
                let data = data
                else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data,
                                                            options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
}

