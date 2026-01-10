//
//  PlanetsViewModelTests.swift
//  Syscolabs-star-war-planetTests
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxTest
@testable import Syscolabs_star_war_planet

class PlanetsListViewModelImplSpec: QuickSpec {
    override class func spec() {
        let bundle = Bundle(for: PlanetsListViewModelImplSpec.self)
        var disposeBag: DisposeBag!
        var useCase: MockPlanetsListUseCase!
        var sut: PlanetsListViewModelImpl!
        var selectedPlanet: PublishSubject<Planet>!
        var viewDidLoad: PublishSubject<Void>!
        beforeEach {
            
            useCase = MockPlanetsListUseCase()
            sut = PlanetsListViewModelImpl(with: useCase)
            disposeBag = DisposeBag()
            selectedPlanet = .init()
            viewDidLoad = .init()
        }
        
        afterEach {
            disposeBag = nil
            sut = nil
            useCase = nil
        }
        
        describe("bind") {
            it("emits loading and loaded states on success") {
                let planets: [Planet] = JsonUtils.convertJsonInto(type: [Planet].self, fileName: "planets", bundle: bundle) ?? []
                useCase.result = .success(planets)
                
                let input = PlanetsListViewModelInput(
                    viewDidLoad: viewDidLoad.asObservable(),
                    didSelectPlanet: selectedPlanet.asObservable()
                )
                
                var states: [State] = []
                sut
                    .bind(input: input)
                    .drive(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
                
                // Trigger viewDidLoad
                viewDidLoad.onNext(())
                
                // Wait for async state emission
                expect(states).toEventually(haveCount(2), timeout: .seconds(2))
                
                
                if case .loaded(let cellViewModels) = states.last {
                    expect(cellViewModels.count) == planets.count
                    expect(cellViewModels.first?.planet.name) == planets.first?.name
                } else {
                    fail("Expected loaded state")
                }
            }
            
            it("emits loading and failes states on error") {
                useCase.result = .failure(NetworkingError.noInterntConnection)
                
                let input = PlanetsListViewModelInput(
                    viewDidLoad: viewDidLoad.asObservable(),
                    didSelectPlanet: selectedPlanet.asObservable()
                )
                
                var states: [State] = []
                sut
                    .bind(input: input)
                    .drive(onNext: { state in
                        states.append(state)
                    })
                    .disposed(by: disposeBag)
                
                // Trigger viewDidLoad
                viewDidLoad.onNext(())
                
                // Wait for async state emission
                expect(states).toEventually(haveCount(2), timeout: .seconds(2))
                
                
                if case .failed(let error) = states.last {
                    expect(error).to(matchError(NetworkingError.noInterntConnection))
                } else {
                    fail("Expected failes state")
                }
            }
        }
    }
}



final class MockPlanetsListUseCase: PlanetsListUseCaseProtocol {
    
    var result: Result<[Planet], Error> = .success([])
    
    func fetchPlanetsList() async throws -> [Planet] {
        switch result {
        case .success(let planets):
            return planets
        case .failure(let error):
            throw error
        }
    }
}
