//
//  MockDataProvider.swift
//  Syscolabs-star-war-planetTests
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import RxSwift
@testable import Syscolabs_star_war_planet

class MockDataProvider: DataProvider {
    
  private let bundle = Bundle(for: MockDataProvider.self)
  var mockFileName: String = ""
  var mockError: NetworkingError?
    
    func execute<T>(apiTarget: APITarget) async throws -> Response<T> where T: Decodable {
        
        guard mockError == nil else {
            throw mockError!
        }
        
        guard let decodable = JsonUtils.convertJsonInto(
            type: T.self,
            fileName: mockFileName,
            bundle: bundle,
            inDirectory: nil
        ) else {
            throw NetworkingError.invalidData
        }
        
        return Response(
            value: decodable,
            response: HTTPURLResponse(
                url: URL(string: "mock-response")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ) ?? URLResponse()
        )
    }
}
