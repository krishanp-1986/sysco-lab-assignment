//
//  PlanetsUseCaseTests.swift
//  Syscolabs-star-war-planetTests
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import XCTest
import Quick
import Nimble
@testable import Syscolabs_star_war_planet

final class PlanetsUseCaseTests: AsyncSpec {
    override class func spec() {
        let bundle = Bundle(for: PlanetsUseCaseTests.self)
        var sut: PlanetsListUseCaseProtocol!
        var repository: MockPlanetsRepository!
        
        beforeEach {
            repository = MockPlanetsRepository()
            sut = PlanetsListUseCase(repository: repository)
        }
        describe("Planets List UseCase") {
            context("When succesfull response", closure: {
                it("Should return valid plantes list") {
                    let planets: [Planet] = JsonUtils.convertJsonInto(type: [Planet].self, fileName: "planets", bundle: bundle) ?? []
                    repository.result = .success(planets)
                    
                    let response: [Planet] = try await sut.fetchPlanetsList()
                    
                    expect(response).toNot(beNil())
                    expect(response.first?.name).to(equal("Tatooine"))
                    
                }
            })
            
            context("When response fails", closure: {
                it("Should return networking error") {
                    repository.result = .failure(NetworkingError.invalidResponse)
                    await expect {
                        try await sut.fetchPlanetsList()
                    }.to(throwError())
                }
            })
        }
        
    }
}


class MockPlanetsRepository: PlanetsRepositoryProtocol {
    
    var result: Result<[Planet], Error> = .success([])
    
    func fetchPlanets() async throws -> [Planet] {
        switch result {
        case .success(let planets):
            return planets
        case .failure(let error):
            throw error
        }
    }
}
