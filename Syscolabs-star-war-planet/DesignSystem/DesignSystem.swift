//
//  DesignSystem.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-09.
//

import Foundation

public class DesignSystem {
  static let shared = DesignSystem()
  private init() {
    self.colors = .init()
    self.fonts = .init()
    self.sizer = .init()
  }
  
  public let colors: DesignSystem.Colors
  public let fonts: DesignSystem.Fonts
  public let sizer: DesignSystem.Sizers
}
