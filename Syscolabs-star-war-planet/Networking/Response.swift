//
//  Response.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-09.
//

import Foundation

public struct Response<T> {
    public let value: T
    public let response: URLResponse
    
    init(value: T, response: URLResponse) {
        self.value = value
        self.response = response
    }
}
