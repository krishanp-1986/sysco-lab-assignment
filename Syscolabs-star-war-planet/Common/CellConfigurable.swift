//
//  CellConfigurable.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit

protocol CellConfigurable: UITableViewCell {
    associatedtype ViewModel
    func configure(with viewModel: ViewModel)
}
