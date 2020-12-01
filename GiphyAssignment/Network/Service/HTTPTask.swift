//
//  HTTPTask.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 27/11/20.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request

    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
