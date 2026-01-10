//
//  NetworkingError.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-09.
//

import Foundation


public enum NetworkingError: Error {
    case invalidResponse
    case invalidData
    case noInterntConnection
    case error(Error)
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .invalidData:
            return "Server failed to return Data"
        case .noInterntConnection:
            return "Please check your connection"
        case .error:
            return "Something went wrong."
        }
    }
}
