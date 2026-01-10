//
//  ViewController+Rx.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoaded: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in  Void() }
        return ControlEvent(events: source)
    }
    
    /// `ControlEvent` for the `viewWillAppear` event of the view controller.
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in  Void() }
        return ControlEvent(events: source)
    }
}
