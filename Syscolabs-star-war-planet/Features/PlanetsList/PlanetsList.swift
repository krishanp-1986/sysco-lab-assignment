//
//  Planets.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-09.
//

import Foundation
import UIKit

struct PlanetsList {
    static func build() -> UIViewController {
        let navigationController = UINavigationController()
        let viewController = PlanetsListViewController()
        let useCase = PlanetsListUseCase(dataProvider: DefaultDataProvider())
        let viewModel = PlanetsListViewModelImpl(with: useCase)
        viewController.bindViewModel(viewModel)
        navigationController.viewControllers = [viewController]
        return navigationController
    }
}
