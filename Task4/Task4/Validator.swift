//
//  Validater
//  task4
//
//  Created by D. Serov on 11/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import Foundation

enum ValidateError: String {
    case email = "Некоррентный email"
    case login = "Логин должен состоять из латинских букв, цифр, минуса и точки"
    case count = "Минимальная длина логина - 3 символа, максимальная - 32"
    case firstCharacter = "Логин не может начинаться на цифру, точку, минус"
}

struct ValidResponse {
    var error: ValidateError?
    var status: Bool
}

struct Validator {
    private let minCount = 3
    private let maxCount = 32
    private let invalidateFirstCharacters = ".-0987654321"
    private let validateCharacters = "0987654321" + "qwertyuiopasdfghjklzxcvbnm" + "QWERTYUIOPASDFGHJKLZXCVBNM" + "-."
    
    private var username: String
    
    init(username: String) {
        self.username = username
    }
    
    func valid() ->  ValidResponse {
        guard validateCount() else {  
            return ValidResponse(error: ValidateError.count, status: false)
        }
        
        guard validateFirstCharacter() else {
            return ValidResponse(error: ValidateError.firstCharacter, status: false)
        }
        
        
        if isEmail() {
            guard validateEmail() else { 
                return ValidResponse(error: ValidateError.email, status: false)
            }
        } else {
            guard validateLogin() else {
                return ValidResponse(error: ValidateError.login, status: false)
            }
        }
        
        return ValidResponse(error: nil, status: true)
    }
    
    private func validateLogin() -> Bool {
        let set = CharacterSet(charactersIn: username)
        let validSet = CharacterSet(charactersIn: validateCharacters)
        if validSet.isSuperset(of: set) {
            return true
        } else {
            return false
        }
    }
    
    private func validateEmail() -> Bool {
        let regRFC5322 = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let regRFC5322Predicate = NSPredicate(format: "SELF MATCHES[c] %@", regRFC5322)
        if regRFC5322Predicate.evaluate(with: username) {
            return true
        } else {
            return false
        }
    }
    
    private func validateCount() -> Bool {
        return username.count > minCount && username.count < maxCount
    }
    
    private func validateFirstCharacter() -> Bool {
        return !invalidateFirstCharacters.contains(username.first!)
    }
    
    private func isEmail() -> Bool {
        return username.contains("@")
    }
}
