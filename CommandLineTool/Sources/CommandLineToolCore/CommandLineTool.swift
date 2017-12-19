
import Foundation
import Alamofire

public final class CommandLineTool {
    private let arguments: [String]
    var loop = true
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() throws {
        print("Write github user: ")
        let githubService = GithubService()

        while let line = readLine() {
            githubService.fetchReposWith(username: line, completion: { githubResponse in
                if let error = githubResponse.error {
                    print(error.rawValue)
                    return
                }
                githubResponse.repositories?.forEach {
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
    var repositories: [String]?
}

class GithubService { 
    func fetchReposWith(username: String, completion: @escaping ((GithubResponse) -> Void)) {
        var repositories = [String]()
        let url = urlWith(username: username) 
        Alamofire.request(url, method: .get).validate().responseJSON(completionHandler: { response in  
            if let error = response.error { 
                switch error { 
                case URLError.notConnectedToInternet: 
                    completion(GithubResponse(error: ResponseError.internetConnection, repositories: nil))
                default: 
                    completion(GithubResponse(error: ResponseError.unknowError, repositories: nil))
                }
                return
            } 
            
            switch response.result { 
            case .success(let value): 
                guard let arr = value as? [[String: Any]] else {
                    completion(GithubResponse(error: ResponseError.parseError, repositories: nil))
                    return 
                } 
                
                arr.forEach {  
                    if let name = $0["name"] as? String { 
                        repositories.append(name) 
                    } 
                }
                completion(GithubResponse(error: nil, repositories: repositories))
            case .failure:
                if response.response?.statusCode == 404 { 
                    print(ResponseError.userNotFound.rawValue)
                    completion(GithubResponse(error: ResponseError.userNotFound, repositories: nil))
                } else { 
                    completion(GithubResponse(error: ResponseError.unknowError, repositories: nil))
                }
            }
        }) 
    } 
    
    private func urlWith(username: String) -> URL { 
        return URL(string: "https://api.github.com/users/\(username)/repos")! 
    } 
} 
