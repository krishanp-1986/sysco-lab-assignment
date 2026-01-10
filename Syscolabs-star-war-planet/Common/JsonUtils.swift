//
//  JsonUtils.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-10.
//

import Foundation

struct JsonUtils {
    
    static func convertJsonInto<T: Decodable>(
        type: T.Type,
        fileName: String,
        bundle: Bundle = .main,
        inDirectory: String? = nil
    ) -> T? {
        
        guard let filePath = bundle.path(
            forResource: fileName,
            ofType: "json",
            inDirectory: inDirectory
        ) else { return nil }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
