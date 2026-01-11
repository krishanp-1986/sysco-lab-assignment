//
//  PlanetDetail.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit

struct PlanetDetail {
    static func build(navigationController: UINavigationController, planet: Planet) -> UIViewController {
        let viewController = PlanetDetailViewController()
        let viewMdel = PlanetDetailViewModelImpl(planet: planet)
        viewController.bindViewModel(viewMdel)
        return viewController
    }
        
}
