//
//  EndPointType.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 27/11/20.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
