//
//  PlanetsTableViewAdapter.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class PlanetsTableViewAdapter: NSObject {
    typealias DataSource = UITableViewDiffableDataSource<Section, PlanetCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, PlanetCellViewModel>
    
    enum Section {
        case all
    }
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self.datasource
    }
    
        
    func insertPlanets(_ planets: [PlanetCellViewModel]) {
        var snapshot = SnapShot()
        snapshot.appendSections([.all])
        snapshot.appendItems(planets)
        datasource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    var onItemSelected: PublishRelay<Planet> = PublishRelay<Planet>()
    // MARK: Private
    private let tableView: UITableView
    
    private lazy var datasource: DataSource = {
        let dataSource = DataSource(tableView: self.tableView) { tableView, indexPath, viewModel in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PlanetTableViewCell.reuseIdentifier,
                for: indexPath) as? PlanetTableViewCell
            cell?.configure(with: viewModel)
            cell?.selectionStyle = .none
            return cell
        }
        return dataSource
    }()
}

extension PlanetsTableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selected = datasource.itemIdentifier(for: indexPath) else { return }
        self.onItemSelected.accept(selected.planet)
    }
}
