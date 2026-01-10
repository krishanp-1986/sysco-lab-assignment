//
//  PlanetsListUseCase.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation

protocol PlanetsListUseCaseProtocol {
    func fetchPlanetsList() async throws -> [Planet]
}

class PlanetsListUseCase: PlanetsListUseCaseProtocol {
    
    let dataProvider: DataProvider
    let _client: PlanetsAPIClient?
    
    init(dataProvider: DataProvider, _client: PlanetsAPIClient? = nil) {
        self.dataProvider = dataProvider
        self._client = _client
    }
    
    private lazy var client: PlanetsAPIClient = {
        if let _client {
            return _client
        }
        
        return PlanetsClientImpl(with: dataProvider)
    }()
    
    
    func fetchPlanetsList() async throws -> [Planet] {
        try await client.fetchAllPlanets().value
    }
    
}
