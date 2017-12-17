
import Foundation
import Alamofire

public final class CommandLineTool {
    private let arguments: [String]
    var loop = true
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() throws {
        while let line = readLine() {
            let githubService = GithubService()
            githubService.fetchReposWith(username: line, completion: { githubResponse in
                if let error = githubResponse.error {
                    print(error.rawValue)
                    return
                }
                githubResponse.response?.forEach {
                    print($0)
                }
            })
        }
    }
}

enum ResponseError: String { 
    case internetConnection 
    case unknowError 
    case invalidateRequest 
    case parseError 
    case userNotFound 
}

struct GithubResponse {
    var error: ResponseError?
    var response: [String]?
}

class GithubService { 
    func fetchReposWith(username: String, completion: @escaping ((GithubResponse) -> Void)) {
        var repositories = [String]() 
        
        let url = urlWith(username: username) 
        Alamofire.request(url, method: .get).validate().responseJSON(completionHandler: { responce in  
            if let error = responce.error { 
                switch error { 
                case URLError.notConnectedToInternet: 
                    completion(GithubResponse(error: ResponseError.internetConnection, response: nil))
                default: 
                    completion(GithubResponse(error: ResponseError.unknowError, response: nil))
                }
                return
            } 
            
            switch responce.result { 
            case .success(let value): 
                guard let arr = value as? [[String: Any]] else {
                    completion(GithubResponse(error: ResponseError.parseError, response: nil))
                    return 
                } 
                
                arr.forEach {  
                    if let name = $0["name"] as? String { 
                        repositories.append(name) 
                    } 
                } 
                
                completion(GithubResponse(error: nil, response: repositories))
            case .failure:
                if responce.response?.statusCode == 404 { 
                    print(ResponseError.userNotFound.rawValue)
                    completion(GithubResponse(error: ResponseError.userNotFound, response: nil))
                } else { 
                    completion(GithubResponse(error: ResponseError.unknowError, response: nil))
                }
            }
        }) 
    } 
    
    private func urlWith(username: String) -> URL { 
        return URL(string: "https://api.github.com/users/\(username)/repos")! 
    } 
} 
