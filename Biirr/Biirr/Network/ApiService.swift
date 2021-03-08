//
//  BeerGarden.swift
//  InfiniumTest
//
//  Created by andrii on 05/03/2021.
//

import Foundation
import Moya

class ApiService {
    
    private var provider: MoyaProvider<BreweryDBAPI>!
    
    var userId: String? {
        return UserDefaults.standard.string(forKey: "authToken")?.components(separatedBy: "-").first
    }
    
    var token: String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }
    
    var getRefreshToken: String? {
        return UserDefaults.standard.string(forKey: "refreshToken")
    }
    
    // MARK: - Singleton
    static let shared = ApiService()
    private init() {
        initProvider()
    }
    
    private func initProvider() {
        let loggerPlugin = NetworkLoggerPlugin()
        loggerPlugin.configuration.logOptions = .verbose
        
        let authPlugin = AccessTokenPlugin { (type) -> String in
            let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
            return token
        }
        provider = MoyaProvider<BreweryDBAPI>(plugins: [authPlugin, loggerPlugin])
    }
                
    func send<T: Codable>(request: BreweryDBAPI, completion: @escaping (Error?, T?) -> ()) -> Cancellable {
        return provider.request(request) { result in
            switch result {
            case let .success(response):
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: response.data)
                    completion(nil, result)
                } catch {
                    completion(error, nil)
                }
            case let .failure(error):
                completion(error, nil)
            }
        }
    }
}

// MARK:- API Enum
public enum BreweryDBAPI{
    static private let key = "13d7fdca22cbc95434f3f65d7be4a5a9"
    static private let baseURLString = "https://api.brewerydb.com/v2"
    case beers(page:Int)
}
// MARK:- Request processing
extension BreweryDBAPI: TargetType {
    public var path: String {
        switch self {
               case .beers:
                return "/beers"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .beers:
            return .get
        default:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self{
        case let .beers (page: page):
            return.requestParameters(parameters: ["key":BreweryDBAPI.key, "p": page], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
  public var baseURL: URL {
    return URL(string: BreweryDBAPI.baseURLString)!
  }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
