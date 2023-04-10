//
//  City.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 10.04.2023.
//

import Foundation

/// A structure that defines the coordinates of a `City` object.
typealias Coordinates = (x: Int, y: Int)

/// A dictionary of `String` keys and `Int` values that represents the balances of a `City` object.
typealias Balances = [String: Int]

/// A class that represents a city in the simulation.
class City {
    /// The coordinates of the city.
    let coordinates: Coordinates
    
    /// The name of the country the city belongs to.
    let countryName: Country.Name
    
    /// The balances of the city.
    var balances = Balances()
    
    /// The cached balances of the city.
    var cachedBalances = Balances()
    
    /// The set of neighboring cities of the city.
    var neighbours = Set<City>()
    
    /// A Boolean value indicating whether the balances of the city are all greater than zero.
    var isComplete: Bool {
        balances.values.allSatisfy { $0 > 0 }
    }
    
    /// Initializes a `City` object with the specified coordinates and country name.
    init(coordinates: Coordinates, countryName: Country.Name) {
        self.coordinates = coordinates
        self.countryName = countryName
    }
    
    /// Updates the balances of the city.
    func updateBalances() {
        guard !cachedBalances.isEmpty else {
            return
        }
        
        for balance in cachedBalances {
            balances[balance.key, default: 0] += balance.value
        }

        cachedBalances = [:]
    }
}

extension City: Hashable, Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.coordinates == rhs.coordinates
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinates.x)
        hasher.combine(coordinates.y)
    }
}
