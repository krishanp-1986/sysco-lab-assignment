//
//  DataProvider.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-09.
//

import Foundation
import Combine

protocol DataProvider {
    func execute<T>(apiTarget: APITarget) async throws -> Response<T> where T: Decodable
}

public struct DefaultDataProvider: DataProvider {
    
    public init() {}
    
    func execute<T: Decodable>(apiTarget: APITarget) async throws -> Response<T>  where T: Decodable {
        switch apiTarget.stubbingBehaviour {
        case .none:
            var request = apiTarget.request
            request.httpMethod = apiTarget.httpMethod.rawValue
            return try await execute(request: request)
            
        case .immediate:
            return try loadResponseFromLocalFile(
                apiTarget.localJsonResourceName ?? "",
                type: T.self,
                bundle: apiTarget.bundle,
                inDirectory: apiTarget.directory
            )
        }
    }
    
    // MARK: - Network
    
    private func execute<T: Decodable>(request: URLRequest) async throws -> Response<T> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return try handleNetworkResponse(data: data, response: response)
        } catch {
            throw mapError(error: error)
        }
    }
    
    // MARK: - Response Handling
    
    private func handleNetworkResponse<T: Decodable>(
        data: Data,
        response: URLResponse
    ) throws -> Response<T> {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            let json = try? JSONSerialization.jsonObject(with: data)
            let error = NSError(
                domain: "",
                code: httpResponse.statusCode,
                userInfo: json as? [String: Any]
            )
            throw NetworkingError.error(error)
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return Response(value: decoded, response: response)
        } catch {
            throw NetworkingError.invalidData
        }
    }
    
    // MARK: - Stubbing
    private func loadResponseFromLocalFile<T: Decodable>(
        _ resourceName: String,
        type: T.Type,
        bundle: Bundle = .main,
        inDirectory: String? = nil
    ) throws -> Response<T> {
        
        guard let decoded = JsonUtils.convertJsonInto(
            type: type,
            fileName: resourceName,
            bundle: bundle,
            inDirectory: inDirectory
        ) else {
            throw NetworkingError.invalidData
        }
        
        let response = HTTPURLResponse(
            url: URL(string: "mock-response")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        return Response(value: decoded, response: response)
    }
    
    // MARK: - Errors
    private func mapError(error: Error) -> NetworkingError {
        error.isNoInternetConnectionError
        ? .noInterntConnection
        : .error(error)
    }
}
