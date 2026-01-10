//
//  PlanetsListViewModel.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import RxSwift
import RxCocoa

protocol PlanetsListViewModel {
    init(with useCase: PlanetsListUseCaseProtocol)
    func bind(input: PlanetsListViewModelInput) -> Driver<State>
}

enum State {
    case loading
    case loaded([PlanetCellViewModel])
    case failed(Error)
}

struct PlanetsListViewModelInput {
    let viewDidLoad: Observable<Void>
    let didSelectPlanet: Observable<Planet>
}

class PlanetsListViewModelImpl: PlanetsListViewModel {
    private let useCase: PlanetsListUseCaseProtocol
    private let state: PublishRelay<State> = .init()
    private let disposeBag = DisposeBag()
    
    required init(with useCase: PlanetsListUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func bind(input: PlanetsListViewModelInput) -> Driver<State> {
        
        disposeBag.insert (
            input
                .viewDidLoad
                .subscribe(onNext: { [weak self] in
                    self?.fetchAllPlanets()
                }),
            
            input
                .didSelectPlanet
                .subscribe(onNext: { [unowned self] planet in
                    // Handle planet selection if needed
                })
        )
        
        return state.asDriver(onErrorJustReturn: .loading)
    }
    
    
    private func fetchAllPlanets() {
        state.accept(.loading)
        Task { [weak self] in
            guard let self else { return }
            
            do {
                let planets = try await useCase.fetchPlanetsList()
                
                await MainActor.run {
                    self.state.accept(.loaded(self.transform(planets: planets)))
                }
            } catch {
                await MainActor.run {
                    self.state.accept(.failed(error))
                }
            }
        }
    }
    
    private func transform(planets: [Planet]) -> [PlanetCellViewModel] {
        planets
            .map { planet in
                PlanetCellViewModel(planet: planet)
            }
    }
}
