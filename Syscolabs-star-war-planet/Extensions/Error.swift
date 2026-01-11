//
//  Error.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation

public extension Error {
    var isNoInternetConnectionError: Bool {
        let nsError = self as NSError
        
        let networkErrorCodes = [
            NSURLErrorNotConnectedToInternet,
            NSURLErrorTimedOut,
            NSURLErrorNetworkConnectionLost,
            NSURLErrorCannotParseResponse,
            NSURLErrorCannotConnectToHost,
            NSURLErrorDataNotAllowed
        ]
        
        return nsError.domain == NSURLErrorDomain && networkErrorCodes.contains(nsError.code)
    }
}


public extension NSError {
    static var noSearchResults: NSError {
        NSError(domain: "com.syscolabs.starwarplanet", code: 404, userInfo: [NSLocalizedDescriptionKey: "No results found for your search."])
    }
}
