import Foundation
struct Planet: Codable {
    let name, orbitalPeriod: String
    let climate, gravity: String

    enum CodingKeys: String, CodingKey {
        case name, climate, gravity
        case orbitalPeriod = "orbital_period"
    }
    
    init(name: String, orbitalPeriod: String, climate: String, gravity: String) {
        self.name = name
        self.orbitalPeriod = orbitalPeriod
        self.climate = climate
        self.gravity = gravity
    }
}
