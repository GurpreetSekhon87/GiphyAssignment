//
//  GiphyAPIRequestModel.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 26/11/20.
//

import Foundation

/// Giphy API Request Model
class GiphyAPIRequestModel: Codable {
    public var api_key: String
    public var q: String?
    public var limit: String
    public var offset: String
    public var rating: String
    public var lang: String
    public var random_id: String

    public init(api_key: String, q: String? = nil, limit: String, offset: String, rating: String, lang: String, random_id: String) {
        self.api_key = api_key
        self.q = q
        self.limit = limit
        self.offset = offset
        self.rating = rating
        self.lang = lang
        self.random_id = random_id
    }
}

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
