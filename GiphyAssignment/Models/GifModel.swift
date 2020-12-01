//
//  GifModel.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 26/11/20.
//

import Foundation
import GRDB
import RxSwift
import RxGRDB

/// GifModel - Model Class
class GifModel: Codable, FetchableRecord, MutablePersistableRecord {
    public var type: String?
    public var id: String?
    public var images: [String: [String: String]]?
    public var url: String?

    public init() {}

    enum GifModelKeys: String, CodingKey, ColumnExpression {
        case type, id, images, url
    }

    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GifModelKeys.self)
        self.type = try values.decodeIfPresent(String.self, forKey: .type)
        self.id = try values.decodeIfPresent(String.self, forKey: .id)
        self.images = try values.decodeIfPresent([String: [String: String]].self, forKey: .images)
        self.url = try values.decodeIfPresent(String.self, forKey: .url)

    }

    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GifModelKeys.self)
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.images, forKey: .images)
        try container.encodeIfPresent(self.url, forKey: .url)
    }
}
