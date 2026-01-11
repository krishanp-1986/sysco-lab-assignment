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
    let query: Observable<String>
}

class PlanetsListViewModelImpl: PlanetsListViewModel {
    private let useCase: PlanetsListUseCaseProtocol
    private let state: PublishRelay<State> = .init()
    private let router: PlanetsRouter
    private let disposeBag = DisposeBag()
    private var planets: [Planet] = []
    private var filteredPlanets: [Planet] = []
    
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
                .query
                .skip(1)
                .subscribe(onNext: { [unowned self] query in
                    return self.filterPlanets(with: query)
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
                    self.filteredPlanets = planets
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
                PlanetCellViewModel(name: planet.name, climate: planet.climate, imageURL: generateUniqueImageURL(name: planet.name))
            }
    }
    
    // This is to store UUID for each planet. So when we filter / Search, we will still return same URL instead of totally random.
    private var uniqueImageIds: [String: String] = [:]
    private func generateUniqueImageURL(name: String) -> URL? {
        let randomId = uniqueImageIds[name] ?? UUID().uuidString
        uniqueImageIds[name] = randomId
        return URL(string: "https://picsum.photos/200?random=\(randomId)")
    }
    
    private func filterPlanets(with query: String) {
        guard !query.isEmpty else {
            self.filteredPlanets = planets
            self.state.accept(.loaded(self.transform(planets: planets)))
            return
        }
        let filteredPlanets = planets.filter { $0.name.lowercased().contains(query.lowercased()) }
        self.filteredPlanets = filteredPlanets
    
        if filteredPlanets.isEmpty {
            self.state.accept(.failed(NSError.noSearchResults))
            return
        }
        
        self.state.accept(.loaded(self.transform(planets: filteredPlanets)))
    }
        
    
    private func navigateToPlanetDetails(at index: Int) {
        let planet = self.filteredPlanets[index]
        router.navigateToDetails(planet: planet)
    }
}


