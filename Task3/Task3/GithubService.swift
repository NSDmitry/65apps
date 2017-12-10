//
//  GithubService.swift
//  Task3
//
//  Created by D. Serov on 11/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import Foundation
import Alamofire

enum ResponceError: String {
    case internetConnection
    case unknowError
    case invalidateRequest
    case parseError
    case userNotFound
}

class GithubService {
    func fetchReposWith(username: String) {
        var repositories = [String]()
        
        let url = urlWith(username: username)
        Alamofire.request(url, method: .get).validate().responseJSON(completionHandler: { responce in 
            if let error = responce.error {
                switch error {
                case URLError.notConnectedToInternet:
                    print("no internet connection")
                default:
                    print("error")
                }
                return
            }
            
            switch responce.result {
            case .success(let value):
                guard let arr = value as? [[String: Any]] else {
                    print(ResponceError.parseError.rawValue)
                    return
                }
                
                arr.forEach { 
                    if let name = $0["name"] as? String {
                        repositories.append(name)
                    }
                }
                
                print(repositories)
            case .failure(let error):
                if responce.response?.statusCode == 404 {
                    print(ResponceError.userNotFound.rawValue)
                } else {
                    print(error)
                }
            }
        })
    }
    
    private func urlWith(username: String) -> URL {
        return URL(string: "https://api.github.com/users/\(username)/repos")!
    }
}

