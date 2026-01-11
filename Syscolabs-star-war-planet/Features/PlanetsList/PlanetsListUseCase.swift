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
        
    private let repository: PlanetsRepositoryProtocol
    
    init(repository: PlanetsRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func fetchPlanetsList() async throws -> [Planet] {
        try await repository.fetchPlanets()
    }
    
}
