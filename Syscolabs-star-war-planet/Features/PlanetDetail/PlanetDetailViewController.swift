//
//  PlanetDetailViewController.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit

class PlanetDetailViewController: BaseViewController<PlanetDetailViewModel> {
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, oribitalPeriodLabel, gravityLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = CGFloat(DesignSystem.shared.sizer.md)
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.textColor = DesignSystem.shared.colors.textPrimary
        label.font = DesignSystem.shared.fonts.header
        return label
    }()
    
    private lazy var oribitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .center
        label.textColor = DesignSystem.shared.colors.textSecondary
        label.font = DesignSystem.shared.fonts.description
        return label
    }()
    
    private lazy var gravityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .center
        label.textColor = DesignSystem.shared.colors.textSecondary
        label.font = DesignSystem.shared.fonts.description
        return label
    }()
    
    override func loadView() {
        super.loadView()
        buildUI()
    }
    
    override func bindViewModel() {
        nameLabel.text = viewModel.planet.name
        oribitalPeriodLabel.text = "Orbital Period: \(viewModel.planet.orbitalPeriod)"
        gravityLabel.text = "Gravity: \(viewModel.planet.gravity)"
    }
    
    private func buildUI() {
        self.view.addSubview(containerStackView)

        let safeAreaLayoutGuilde = self.view.safeAreaLayoutGuide
        containerStackView.snp.makeConstraints {
            $0.center.equalTo(safeAreaLayoutGuilde)
        }
    }
}
