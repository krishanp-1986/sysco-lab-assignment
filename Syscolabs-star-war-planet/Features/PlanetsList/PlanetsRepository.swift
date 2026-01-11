//
//  PlanetsRepository.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-11.
//

import Foundation

protocol PlanetsRepositoryProtocol {
    func fetchPlanets() async throws -> [Planet]
}

final class PlanetsRepository: PlanetsRepositoryProtocol {
    
    private let apiClient: PlanetsAPIClient
    private let realmManager: RealManagerProtocol
    
    init(apiClient: PlanetsAPIClient, realmManager: RealManagerProtocol = RealmManager.shared) {
        self.apiClient = apiClient
        self.realmManager = realmManager
    }
    
    func fetchPlanets() async throws -> [Planet] {
        let cachedEntities = realmManager.fetchPlanets()
        let isValid = realmManager.isCacheValid(maxAge: cacheTTL)
        
        if !cachedEntities.isEmpty && isValid {
            return cachedEntities.map { $0.toDomain() }
        }
        
        realmManager.clear()
        let remotePlanets = try await apiClient.fetchAllPlanets().value
        self.realmManager.savePlanets(planets: remotePlanets)
        realmManager.updateCacheTimestamp()
        return remotePlanets
    }
}
