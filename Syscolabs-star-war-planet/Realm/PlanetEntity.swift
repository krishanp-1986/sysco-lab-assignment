//
//  PlanetEntity.swift
//  Syscolabs-star-war-planet
//
//  Created by Krishantha Sunil Premaretna on 2026-01-11.
//

import Foundation
import RealmSwift

final class PlanetEntity: Object {
    @Persisted(primaryKey: true) var name: String
    @Persisted var climate: String
    @Persisted var gravity: String
    @Persisted var orbitalPeriod: String
}


extension PlanetEntity {
    convenience init(dto: Planet) {
        self.init()
        self.name = dto.name
        self.climate = dto.climate
        self.gravity = dto.gravity
        self.orbitalPeriod = dto.orbitalPeriod
    }
    
    func toDomain() -> Planet {
        Planet(
            name: name,
            orbitalPeriod: orbitalPeriod,
            climate: climate,
            gravity: gravity
        )
    }
}
