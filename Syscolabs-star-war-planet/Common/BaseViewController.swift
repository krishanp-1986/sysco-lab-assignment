//
//  BaseViewController.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController<VM>: UIViewController, BindableType {
    var viewModel: VM!
    let disposeBag: DisposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = DesignSystem.shared.colors.backgroundPrimary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        fatalError("Subclass must override")
    }
}
