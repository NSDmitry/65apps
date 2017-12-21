import Alamofire
import Foundation

print("Write gitub nickname")
let username = readLine()
Alamofire.request("https://api.github.com/users/\(username!)/repos").validate().responseJSON { response in
    enum ResponseError: String {
        case internetConnection
        case unknowError
        case invalidateRequest
        case parseError
        case userNotFound
    }
    
    if let error = response.error {
        switch error {
        case URLError.notConnectedToInternet:
            print(ResponseError.internetConnection.rawValue)
        default:
            print(ResponseError.unknowError.rawValue)
            return
        }
    }
    
    switch response.result {
    case .success(let value):
        guard let arr = value as? [[String: Any]] else {
            print(ResponseError.parseError.rawValue)
            return
        }
        var repositories = [String]()
        arr.forEach {
            if let name = $0["name"] as? String {
                repositories.append(name)
            }
        }
        print(repositories)
        exit(0)
    case .failure:
        if response.response?.statusCode == 404 {
            print(ResponseError.userNotFound.rawValue)
        } else {
            print(ResponseError.unknowError.rawValue)
        }
    }
}

let runLoop = RunLoop.current
while (true && runLoop.run(mode: .defaultRunLoopMode, before: .distantFuture)) {}
