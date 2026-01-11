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
        self.contentView.backgroundColor = DesignSystem.shared.colors.backgroundPrimary
        self.backgroundColor = DesignSystem.shared.colors.backgroundPrimary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.asyncImageView.cancel()
    }
    
    // MARK: - Private
    private func buildUI() {
        self.contentView.addSubview(asyncImageView)
        self.contentView.addSubview(labelContainer)
        
        let mediumSize = DesignSystem.shared.sizer.md
        
        self.asyncImageView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(mediumSize)
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
        
        labelContainer.snp.makeConstraints {
            $0.left.equalTo(self.asyncImageView.snp.right).offset(mediumSize)
            $0.centerY.equalToSuperview()
            
        }
    }
    
    private lazy var asyncImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        return imageView
    }()
    
    private lazy var labelContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, climateLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = CGFloat(DesignSystem.shared.sizer.md)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
        self.asyncImageView.load(url: viewModel.imageURL)
    }
}

struct PlanetCellViewModel {
    let name: String
    let climate: String
    let imageURL: URL?
}

extension PlanetCellViewModel: Hashable {
    static func == (lhs: PlanetCellViewModel, rhs: PlanetCellViewModel) -> Bool {
        (lhs.name == rhs.name)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}

