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
        let name = "dmitrygmail.com"
        let validator = Validator(username: name)
        let response = validator.valid()
        if let error = response.error {
            print(error.rawValue)
            return
        }
        print("Validate ok")
    }
}

