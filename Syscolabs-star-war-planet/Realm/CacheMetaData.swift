//
//  CacheMetaData.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-11.
//

import Foundation
import RealmSwift

// Global Variable to define cache TTL (Time To Live) duration ( 5 Minutes)
let cacheTTL: TimeInterval = 5 * 60

// This is to keep track of cache metadata such as last updated timestamps.
class CacheMetadata: Object {
    @Persisted(primaryKey: true) var key: String
    @Persisted var lastUpdated: Date
}
