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
        let router = PlanetsRouterImpl(rootViewController: navigationController)
        let viewModel = PlanetsListViewModelImpl(with: useCase, router: router)
        viewController.bindViewModel(viewModel)
        navigationController.viewControllers = [viewController]
        return navigationController
    }
}
