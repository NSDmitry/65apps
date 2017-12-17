//
//  ViewController.swift
//  Task4
//
//  Created by D. Serov on 11/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = "dmitry@gmail.com"
        let validResponse = Validator.valid(username: name)
        if let error = validResponse.error {
            print("valid error = \(error.rawValue)")
            return
        }
        print("Validate ok")
    }
}

