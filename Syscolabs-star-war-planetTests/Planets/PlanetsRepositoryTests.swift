//
//  PlanetsRepositoryTests.swift
//  Syscolabs-star-war-planetTests
//
//  Created by Krishantha Sunil Premaretna on 2026-01-11.
//

import XCTest
import Quick
import Nimble
@testable import Syscolabs_star_war_planet

final class PlanetsRepositoryTests: AsyncSpec {
    override class func spec() {
        var apiClient: MockPlanetsAPIClient!
        var realmManager: MockRealmManager!
        var repository: PlanetsRepository!
        
        beforeEach {
            apiClient = MockPlanetsAPIClient()
            realmManager = MockRealmManager()
            repository = PlanetsRepository(
                apiClient: apiClient,
                realmManager: realmManager
            )
        }
        
        describe("fetchPlanets") {
            
            context("when cache exists and is valid") {
                
                beforeEach {
                    realmManager.cacheValid = true
                    realmManager.cachedPlanets = [
                        PlanetEntity.stub(name: "Tatooine")
                    ]
                }
                
                it("returns cached planets without calling API") {
                    
                    let response: [Planet] = try await repository.fetchPlanets()
                    
                    expect(response).to(equal([Planet.stub(name: "Tatooine")]))
                    expect(apiClient.fetchCalled).to(beFalse())
                    expect(realmManager.clearCalled).to(beFalse())
                    
                }
            }
        }
        
        context("when cache exists but is expired") {
            
            beforeEach {
                realmManager.cacheValid = false
                realmManager.cachedPlanets = [
                    PlanetEntity.stub(name: "Hoth")
                ]
                apiClient.planetsToReturn = [
                    Planet.stub(name: "Naboo")
                ]
            }
            
            it("clears cache, fetches from API and saves new data") {
                let result = try await repository.fetchPlanets()
                
                expect(result).to(equal([Planet.stub(name: "Naboo")]))
                expect(realmManager.clearCalled).to(beTrue())
                expect(apiClient.fetchCalled).to(beTrue())
                expect(realmManager.saveCalled).to(beTrue())
                expect(realmManager.updateTimestampCalled).to(beTrue())
                
            }
        }
        
        context("when cache is empty") {
            
            beforeEach {
                realmManager.cacheValid = false
                realmManager.cachedPlanets = []
                apiClient.planetsToReturn = [
                    Planet.stub(name: "Dagobah")
                ]
            }
            
            it("fetches from API and caches result") {
                let result = try await repository.fetchPlanets()
                
                expect(result).to(equal([Planet.stub(name: "Dagobah")]))
                expect(apiClient.fetchCalled).to(beTrue())
                expect(realmManager.saveCalled).to(beTrue())
                
                
            }
        }
        
        context("when API fails") {
            
            beforeEach {
                realmManager.cacheValid = false
                realmManager.cachedPlanets = []
                apiClient.shouldThrow = true
            }
            
            it("throws an error") {
                Task  {
                    await expect {
                        try await repository.fetchPlanets()
                    }.to(throwError())
                }
            }
        }
    }
}

class MockRealmManager: RealManagerProtocol {
    
    var cachedPlanets: [PlanetEntity] = []
    var cacheValid: Bool = false
    
    var clearCalled = false
    var saveCalled = false
    var updateTimestampCalled = false
    
    func fetchPlanets() -> [PlanetEntity] {
        cachedPlanets
    }
    
    func isCacheValid(maxAge: TimeInterval) -> Bool {
        cacheValid
    }
    
    func clear() {
        clearCalled = true
    }
    
    func savePlanets(planets: [Planet]) {
        saveCalled = true
    }
    
    func updateCacheTimestamp() {
        updateTimestampCalled = true
    }
}

enum MockAPIError: Error {
    case failed
}


class MockPlanetsAPIClient: PlanetsAPIClient {
    
    
    var planetsToReturn: [Planet] = []
    var shouldThrow = false
    var fetchCalled = false
    
    func fetchAllPlanets() async throws -> Response<[Planet]> {
        fetchCalled = true
        
        if shouldThrow {
            throw MockAPIError.failed
        }
        
        return  .init(value: planetsToReturn, response: .init())
    }
}


extension PlanetEntity {
    static func stub(name: String) -> PlanetEntity {
        let entity = PlanetEntity()
        entity.name = name
        return entity
    }
}

extension Planet {
    static func stub(name: String) -> Planet {
        Planet(
            name: name,
            orbitalPeriod: "",
            climate: "",
            gravity: ""
        )
    }
}

extension Planet: @retroactive Equatable {
    public static func == (lhs: Planet, rhs: Planet) -> Bool {
        lhs.name == rhs.name &&
        lhs.orbitalPeriod == rhs.orbitalPeriod &&
        lhs.climate == rhs.climate &&
        lhs.gravity == rhs.gravity
    }
}

