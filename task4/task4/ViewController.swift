//
//  ViewController.swift
//  task4
//
//  Created by D. Serov on 11/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = "Dmitry"
        let validater = Validater(username: username)
        validater.valid().status
    }
}

