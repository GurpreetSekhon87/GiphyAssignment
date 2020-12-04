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

    func getGifs(query: String? = nil, offset: Int, completion: @escaping (_ gif: [GifModel]?,_ error: String?)->()){

        if let searchQuery = query {
            router.request(.search(query: searchQuery, offset: offset)) { data, response, error in
                parseAPIResponse(data, response, error) { gifModels, error in
                    completion(gifModels, error)
                }
            }
        } else {
            router.request(.trending(offset: offset)) { data, response, error in
                parseAPIResponse(data, response, error) { gifModels, error in
                    completion(gifModels, error)
                }
            }
        }
    }

    private func parseAPIResponse(_ data: Data?,_ response: URLResponse?,_ error: Error?, completion: @escaping (_ gif: [GifModel]?,_ error: String?)->()) {
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

                        guard let data = dict["data"] as? [[String:AnyObject]] else {
                            return
                        }

                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
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

