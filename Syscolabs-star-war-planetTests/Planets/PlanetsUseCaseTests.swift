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

final class PlanetsUseCaseTests: QuickSpec {
    override class func spec() {
        var sut: PlanetsListUseCaseProtocol!
        var dataProvider: MockDataProvider!
        
        beforeEach {
            dataProvider = MockDataProvider()
            sut = PlanetsListUseCase(dataProvider: dataProvider)
        }
        describe("Planets List UseCase") {
            context("When succesfull response", closure: {
                it("Should return valid plantes list") {
                    waitUntil(timeout: .seconds(2)) { done in
                        Task {
                            do {
                                dataProvider.mockFileName = "planets"
                                let response: [Planet] = try await sut.fetchPlanetsList()
                                
                                expect(response).toNot(beNil())
                                expect(response.first?.name).to(equal("Tatooine"))
                                
                            } catch {
                                fail("Expected success but got error: \(error)")
                            }
                            done()
                        }
                    }
                }
            })
            
            context("When response fails", closure: {
                it("Should return networking error") {
                    waitUntil(timeout: .seconds(2)) { done in
                        Task {
                            do {
                                dataProvider.mockError = .invalidResponse
                                let response: [Planet] = try await sut.fetchPlanetsList()
                                fail("Expected error but got success: \(response)")
                                
                            } catch {
                                expect(error).to(matchError(NetworkingError.invalidResponse))
                            }
                            done()
                        }
                    }
                }
            })
        }
            
    }
}
