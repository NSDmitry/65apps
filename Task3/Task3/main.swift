//
//  main.swift
//  Task3
//
//  Created by D. Serov on 11/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import Foundation

let username = readLine()
let service = GithubService()
service.fetchReposWith(username: username!)


