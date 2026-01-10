//
//  PlanetsClient.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation

protocol PlanetsAPIClient {
    func fetchAllPlanets() async throws -> Response<[Planet]>
}


public struct PlanetsClientImpl: PlanetsAPIClient {

    private let dataProvider: DataProvider
    
    enum EndPpoint: APITarget {
        case fetchAllPlanets
        case featchDetails(id: Int)
        
        
        var request: URLRequest {
            URLRequest(url: url)
        }
        
        private var url: URL {
            let baseUrlString = "https://swapi.info/api/planets"
            guard let baseUrl = URL(string: baseUrlString) else {
                fatalError("Invalid base URL")
            }
            
            switch self {
            case .fetchAllPlanets:
                return baseUrl
            case .featchDetails(let id):
                return baseUrl
                    .appendingPathComponent("\(id)")
            }
        }
        var httpMethod: HttpMethod {
            .get
        }
        
        var stubbingBehaviour: StubbingBehaviour {
            .none
        }
    }


    init(with dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchAllPlanets() async throws -> Response<[Planet]> {
        try await dataProvider.execute(apiTarget: EndPpoint.fetchAllPlanets)
    }
}
