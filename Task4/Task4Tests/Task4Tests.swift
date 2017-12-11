//
//  Task4Tests.swift
//  Task4Tests
//
//  Created by D. Serov on 11/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import XCTest

class Task4Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmails() {
        let validEmails = [
            "email@example.com",
            "firstname.lastname@example.com",
            "email@subdomain.example.com", 
            "firstname+lastname@example.com",
            "email@123.123.123.123", 
            "email@example.name",
            "email@example.museum", 
            "firstname-lastname@example.com"
        ]
        
        let invalidEmails = [
            "#@%^%#$@#$@#.com",
            "@example.com", 
            "Joe Smith <email@example.com>", 
            "email@example@example.com", 
            ".email@example.com",
            "email.@example.com",
            "email..email@example.com",
            "email@example.com (Joe Smith)",
            "email@-example.com"
        ]
        
        validEmails.forEach { email in 
            let validator = Validator(username: email)
            let response = validator.valid()
            XCTAssertEqual(response.status, true, "\(email) - status - \(response.error?.rawValue ?? "")")
        }
        
        invalidEmails.forEach { email in 
            let validator = Validator(username: email)
            let response = validator.valid()
            XCTAssertEqual(response.status, false, "\(email) - status - \(response.error?.rawValue ?? "")")
        }
    }
    
    // Длина от 3 до 32, латиница, цифры, минус, точка
    // Не может начинаться на точку, цифру, минус
    
    func testUsernames() {
        let validUsernames = ["BestNameEver", "PrettyinPink", "Saphireflames", "Miss.Sporty135", "Selena1", "dsa-"]
        let invalidUsernames = ["Beautiful Liar", "ki$$ntell", "JosieandthepussycatsJosieandthepussycatsJosieandthepussycats", "11HannaH"]
        
        validUsernames.forEach { name in 
            let validator = Validator(username: name)
            let response = validator.valid()
            XCTAssertEqual(response.status, true, "\(name) - status - \(response.error?.rawValue ?? "")")
        }
        
        invalidUsernames.forEach { name in 
            let validator = Validator(username: name)
            let response = validator.valid()
            XCTAssertEqual(response.status, false, "\(name) - status - \(response.error?.rawValue ?? "")")
        }

    }
}
