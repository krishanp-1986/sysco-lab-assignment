//
//  APITarget.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-09.
//

import Foundation

public enum StubbingBehaviour {
    case none
    case immediate
}

public protocol StubbedAPI {
    var stubbingBehaviour: StubbingBehaviour { get }
    var localJsonResourceName: String? { get }
    var bundle: Bundle { get }
    var directory: String? { get }
}

public extension StubbedAPI {
    var stubbingBehaviour: StubbingBehaviour { .none }
    var localJsonResourceName: String? { nil }
    var bundle: Bundle {
        .main
    }
    var directory: String? { "TestResponse" }
}

public enum HttpMethod: String {
    case get = "GET"
    //TODO: We can add the remaining later
}

public protocol APITarget: StubbedAPI {
    var request: URLRequest { get }
    var httpMethod: HttpMethod { get }
}

