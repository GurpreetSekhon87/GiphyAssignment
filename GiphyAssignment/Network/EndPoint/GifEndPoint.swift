//
//  GifEndPoint.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 27/11/20.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum GiphyApi {
    case trending(page:Int)
    case search(query:String)
}

extension GiphyApi: EndPointType {

    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return giphyAPIBaseUrl
        case .qa: return giphyAPIBaseUrl
        case .staging: return giphyAPIBaseUrl
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .trending:
            return "trending"
        case .search:
            return "search"
        }
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        switch self {
        case .trending:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key": giphyAPIKey, "limit": "10",
                                                      "offset": "0", "rating": "g", "lang": "en",
                                                      "random_id": "e826c9fc5c929e0d6c6d423841a282aa"])
        case .search(let query):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key": giphyAPIKey, "limit": "20",
                                                      "offset": "0", "q": query ,"rating": "g", "lang": "en",
                                                      "random_id": "e826c9fc5c929e0d6c6d423841a282aa"])
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
