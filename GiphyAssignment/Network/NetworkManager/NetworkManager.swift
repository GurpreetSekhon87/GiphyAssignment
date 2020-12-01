//
//  NetworkManager.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 27/11/20.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .staging
    let router = Router<GiphyApi>()

    func getTrendingGifs(page: Int, completion: @escaping (_ gif: [GifModel]?,_ error: String?)->()){
        router.request(.trending(page: page)) { data, response, error in

            if error != nil {
                completion(nil, "Please check your network connection.")
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)

                        if let dict = jsonData as? [String: AnyObject] {
                            let jsonData = try JSONSerialization.data(withJSONObject: dict["data"]!, options: JSONSerialization.WritingOptions.prettyPrinted)
                            let apiResponse = try JSONDecoder().decode([GifModel].self, from: jsonData)
                            completion(apiResponse,nil)
                        }
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }

    func getSearchedGifs(query: String, completion: @escaping (_ gif: [GifModel]?,_ error: String?)->()){
        router.request(.search(query: query)) { data, response, error in

            if error != nil {
                completion(nil, "Please check your network connection.")
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)

                        if let dict = jsonData as? [String: AnyObject] {
                            let jsonData = try JSONSerialization.data(withJSONObject: dict["data"]!, options: JSONSerialization.WritingOptions.prettyPrinted)
                            let apiResponse = try JSONDecoder().decode([GifModel].self, from: jsonData)
                            completion(apiResponse,nil)
                        }
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

