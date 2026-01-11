//
//  main.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-11.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("AppDelegateTest") ?? AppDelegate.self

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))

