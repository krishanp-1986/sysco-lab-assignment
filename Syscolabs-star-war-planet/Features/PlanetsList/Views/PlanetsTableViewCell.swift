//
//  PlanetsTableViewCell.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import UIKit
import SnapKit

class PlanetTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func buildUI() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(climateLabel)
        
        let mediumSize = DesignSystem.shared.sizer.md
        
        self.nameLabel.snp.makeConstraints {
            $0.left.top.right.equalToSuperview().inset(mediumSize)
        }
        
        self.climateLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(mediumSize)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(DesignSystem.shared.sizer.sm)
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = DesignSystem.shared.colors.textPrimary
        label.font = DesignSystem.shared.fonts.header
        return label
    }()
    
    private lazy var climateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = DesignSystem.shared.colors.textSecondary
        label.font = DesignSystem.shared.fonts.description
        return label
    }()
}

extension PlanetTableViewCell: CellConfigurable {
    func configure(with viewModel: PlanetCellViewModel) {
        self.nameLabel.text = viewModel.name
        self.climateLabel.text = viewModel.climate
    }
}

struct PlanetCellViewModel {
    let planet: Planet
    
    var name: String {
        planet.name
    }
    
    var climate: String {
        planet.climate
    }
}

extension PlanetCellViewModel: Hashable {
    static func == (lhs: PlanetCellViewModel, rhs: PlanetCellViewModel) -> Bool {
        (lhs.planet.name == rhs.planet.name)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.planet.name)
    }
}

