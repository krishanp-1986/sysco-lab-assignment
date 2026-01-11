//
//  AsyncImageView.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation
import UIKit

final class AsyncImageView: UIImageView {
    
    private var task: Task<Void, Never>?
    
    func load(url: URL?) {
        image = UIImage(systemName: "photo")
        tintColor = .secondaryLabel
        guard let url = url else {
            return
        }
        task?.cancel()
        
        image = UIImage(systemName: "photo")
        tintColor = .secondaryLabel
        
        task = Task {
            if let cached = ImageCache.shared.image(for: url) {
                await MainActor.run {
                    self.image = cached
                    self.tintColor = nil
                }
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { return }
                
                ImageCache.shared.insert(image, for: url)
                
                await MainActor.run {
                    self.image = image
                    self.tintColor = nil
                }
            } catch {
                await MainActor.run {
                    self.image = UIImage(systemName: "exclamationmark.triangle")
                    self.tintColor = .systemRed
                }
            }
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}
