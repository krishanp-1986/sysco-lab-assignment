//
//  PlanetsRouter.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit

protocol PlanetsRouter {
    func navigateToDetails(planet: Planet)
}

struct PlanetsRouterImpl: PlanetsRouter {
    let rootViewController: UINavigationController
    
    func navigateToDetails(planet: Planet) {
        let details = PlanetDetail.build(navigationController: rootViewController, planet: planet)
        rootViewController.present(details, animated: true)
    }
    
}
    
