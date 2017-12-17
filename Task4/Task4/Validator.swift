//
//  Validater
//  task4
//
//  Created by D. Serov on 11/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import Foundation

enum ValidateError: String {
    case email = "Не коррентный email"
    case login = "Логин должен состоять из латинских букв, цифр, минуса и точки"
    case count = "Минимальная длина логина - 3 символа, максимальная - 32"
    case firstCharacter = "Логин не может начинаться на цифру, точку, минус"
}

struct ValidResponse {
    var error: ValidateError?
    var status: Bool
}

class Validator {
    private static let minCount = 3
    private static let maxCount = 32
    private static let invalidateFirstCharacters = ".-0987654321"
    private static let validateCharacters = "0987654321" + "qwertyuiopasdfghjklzxcvbnm" + "QWERTYUIOPASDFGHJKLZXCVBNM" + "-."
    
    class func valid(username: String) ->  ValidResponse {
        guard validateCount(username: username) else {
            return ValidResponse(error: ValidateError.count, status: false)
        }
        
        guard validateFirstCharacter(username: username) else {
            return ValidResponse(error: ValidateError.firstCharacter, status: false)
        }
        
        
        if isEmail(username: username) {
            guard validateEmail(username: username) else {
                return ValidResponse(error: ValidateError.email, status: false)
            }
        } else {
            guard validateLogin(username: username) else {
                return ValidResponse(error: ValidateError.login, status: false)
            }
        }
        
        return ValidResponse(error: nil, status: true)
    }
    
    private class func validateLogin(username: String) -> Bool {
        let set = CharacterSet(charactersIn: username)
        let validSet = CharacterSet(charactersIn: validateCharacters)
        if validSet.isSuperset(of: set) {
            return true
        } else {
            return false
        }
    }
    
    private class func validateEmail(username: String) -> Bool {
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
    
    private static func validateCount(username: String) -> Bool {
        return username.count > minCount && username.count < maxCount
    }
    
    private static func validateFirstCharacter(username: String) -> Bool {
        return !invalidateFirstCharacters.contains(username.first!)
    }
    
    private static func isEmail(username: String) -> Bool {
        return username.contains("@")
    }
}
