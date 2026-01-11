//
//  UIImageView+Caching.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImage(from url: URL, placeholderSystemName: String = "photo") {
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        self.image = UIImage(systemName: placeholderSystemName, withConfiguration: config)
        self.tintColor = .secondaryLabel
        
        Task {
            do {
                let request = URLRequest(
                    url: url,
                    cachePolicy: .returnCacheDataElseLoad,
                    timeoutInterval: 30
                )
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode),
                    let image = UIImage(data: data)
                else {
                    return
                }
                
                await MainActor.run {
                    self.image = image
                }
            } catch {
                await MainActor.run {
                    self.image = UIImage(systemName: "exclamationmark.triangle")
                    self.tintColor = .systemRed
                }
            }
        }
    }
}
