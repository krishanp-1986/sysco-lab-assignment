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
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = DesignSystem.shared.colors.backgroundSecondory
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
    
    func displayBasicAlert(error: Error) {
        let alertViewController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
}
