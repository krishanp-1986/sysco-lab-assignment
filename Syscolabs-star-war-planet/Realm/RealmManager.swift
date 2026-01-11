//
//  RealmManager.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-11.
//

import Foundation
import RealmSwift

protocol RealManagerProtocol {
    func savePlanets(planets: [Planet])
    func fetchPlanets() -> [PlanetEntity]
    func clear()
    func isCacheValid(maxAge: TimeInterval) -> Bool
    func updateCacheTimestamp()
}

final class RealmManager: RealManagerProtocol {

    static let shared = RealmManager()
    private init() {}

    func savePlanets(planets: [Planet]) {
        guard let realm = try? Realm() else {
            return
        }

        let entities = planets.map(PlanetEntity.init)

        try? realm.write {
            realm.add(entities, update: .modified)
        }
    }

    func fetchPlanets() -> [PlanetEntity] {
        guard let realm = try? Realm() else {
            return []
        }
        return Array(realm.objects(PlanetEntity.self))
    }

    func clear() {
        guard let realm = try? Realm() else {
                return
        }
        try? realm.write {
            realm.deleteAll()
        }
    }
}


extension RealmManager {

    private var cacheKey: String { "planets_cache" }

    func isCacheValid(maxAge: TimeInterval) -> Bool {
        guard let realm = try? Realm() else { return false }

        guard let metadata = realm.object(
            ofType: CacheMetadata.self,
            forPrimaryKey: cacheKey
        ) else {
            return false
        }

        return Date().timeIntervalSince(metadata.lastUpdated) < maxAge
    }

    func updateCacheTimestamp() {
        guard let realm = try? Realm() else  { return }
        let metadata = CacheMetadata()
        metadata.key = cacheKey
        metadata.lastUpdated = Date()

        try? realm.write {
            realm.add(metadata, update: .modified)
        }
    }
}
