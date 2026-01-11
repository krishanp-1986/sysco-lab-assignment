//
//  PlanetsListViewController.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearching: Bool {
        searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    
    override func loadView() {
        super.loadView()
        buildUI()
        setupSearchController()
        self.title = "Star Wars Planets"
    }
    
    override func bindViewModel() {
        
        let cancelSearch = searchController.searchBar.rx.cancelButtonClicked
            .map { "" }
        
        let searchQuery = Observable.merge(
                searchController.searchBar.rx.text.orEmpty
                    .debounce(.milliseconds(600), scheduler: MainScheduler.instance)
                    .distinctUntilChanged(),

                cancelSearch
            )
            .share(replay: 1)
        
        let output = viewModel.bind(input:
                .init(
                    viewDidLoad: self.rx.viewWillAppear.asObservable(),
                    selectedIndex: self.tableViewAdapter.selectedIndex.asObservable(),
                    query: searchQuery
                ))
        
        disposeBag.insert (
            output
                .drive(onNext: { [weak self] state in
                    self?.handleStateChanges(state: state)
                }),
            
            searchController.searchBar.rx.cancelButtonClicked
                .subscribe(onNext: { [weak self] in
                    self?.view.endEditing(true)
                })
        )
    }
    
    //MARK: - Private
    private func buildUI() {
        self.view.addSubview(planetsTableView)
        let safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
        self.planetsTableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Planets"

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
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
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func dataLoaded(cellModels: [PlanetCellViewModel]) {
        self.activityIndicator.removeFromSuperview()
        self.tableViewAdapter.insertPlanets(cellModels)
    }
    
    private func handleError(error: Error) {
        self.tableViewAdapter.insertPlanets([])
        self.activityIndicator.removeFromSuperview()
        self.displayBasicAlert(error: error)
        
    }
}
