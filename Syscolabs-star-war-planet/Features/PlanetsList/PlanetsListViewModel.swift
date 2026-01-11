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
    init(with useCase: PlanetsListUseCaseProtocol, router: PlanetsRouter)
    func bind(input: PlanetsListViewModelInput) -> Driver<State>
}

enum State {
    case loading
    case loaded([PlanetCellViewModel])
    case failed(Error)
}

struct PlanetsListViewModelInput {
    let viewDidLoad: Observable<Void>
    let selectedIndex: Observable<Int>
}

class PlanetsListViewModelImpl: PlanetsListViewModel {
    private let useCase: PlanetsListUseCaseProtocol
    private let state: PublishRelay<State> = .init()
    private let router: PlanetsRouter
    private let disposeBag = DisposeBag()
    private var planets: [Planet] = []
    
    required init(with useCase: PlanetsListUseCaseProtocol, router: PlanetsRouter) {
        self.useCase = useCase
        self.router = router
    }
    
    func bind(input: PlanetsListViewModelInput) -> Driver<State> {
        
        disposeBag.insert (
            input
                .viewDidLoad
                .subscribe(onNext: { [weak self] in
                    self?.fetchAllPlanets()
                }),
            
            input
                .selectedIndex
                .subscribe(onNext: { [unowned self] index in
                    self.navigateToPlanetDetails(at: index)
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
                self.planets = planets
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
                PlanetCellViewModel(name: planet.name, climate: planet.climate, imageURL: generateUniqueImageURL())
            }
    }
    
    private func generateUniqueImageURL() -> URL? {
        URL(string: "https://picsum.photos/200?random=\(UUID().uuidString)")
    }
        
    
    private func navigateToPlanetDetails(at index: Int) {
        let planet = planets[index]
        router.navigateToDetails(planet: planet)
    }
}
