//
//  Planets.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-09.
//

import Foundation
import UIKit

struct Planets {
    static func build() -> UIViewController {
        let navigationController = UINavigationController()
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        return viewController
    }
}
