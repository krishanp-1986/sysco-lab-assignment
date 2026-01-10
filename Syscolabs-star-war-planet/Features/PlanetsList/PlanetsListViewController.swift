//
//  PlanetsListViewController.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit
import SnapKit

class PlanetsListViewController: BaseViewController<PlanetsListViewModel> {
        
    private lazy var planetsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.registerCell(PlanetTableViewCell.self)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var tableViewAdapter: PlanetsTableViewAdapter = {
        let adapter = PlanetsTableViewAdapter(with: planetsTableView)
        return adapter
    }()
    
    override func loadView() {
        super.loadView()
        buildUI()
    }
    
    override func bindViewModel() {
        
        let output = viewModel.bind(input:
                .init(
                    viewDidLoad: self.rx.viewWillAppear.asObservable(),
                    didSelectPlanet: self.tableViewAdapter.onItemSelected.asObservable()
                ))
        
        disposeBag.insert {
            output
                .drive(onNext: { [weak self] state in
                    self?.handleStateChanges(state: state)
                })
        }
    }
    
    //MARK: - Private
    private func buildUI() {
        self.view.addSubview(planetsTableView)
        let safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
        self.planetsTableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func handleStateChanges(state: State) {
        switch state {
        case .loading:
            displayLoadingIndicator()
        case .loaded(let array):
            dataLoaded(cellModels: array)
        case .failed(let error):
            handleError(error: error)
        }
    }
    
    private func displayLoadingIndicator() {
    }
    
    private func dataLoaded(cellModels: [PlanetCellViewModel]) {
        self.tableViewAdapter.insertPlanets(cellModels)
    }
        
    private func handleError(error: Error) {}
}

