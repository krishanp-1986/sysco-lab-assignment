//
//  PlanetDetailViewModel.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation

protocol PlanetDetailViewModel {
    var planet: Planet { get }
    init(planet: Planet)
}

class PlanetDetailViewModelImpl: PlanetDetailViewModel {
    let planet: Planet
    required init(planet: Planet) {
        self.planet = planet
    }
}
