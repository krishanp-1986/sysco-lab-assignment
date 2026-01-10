//
//  Reusable.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit

protocol Reusable {
    typealias Cell = UITableViewCell & Reusable
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: type(of: self))
    }
}

extension UITableView {
    func registerCell<C>(_ type: C.Type) where C: Reusable.Cell {
        register(type, forCellReuseIdentifier: C.reuseIdentifier)
    }
}

