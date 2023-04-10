//
//  Country.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 10.04.2023.
//

import Foundation

/// A geographic region containing cities.
class Country {
    /// The name of the country.
    typealias Name = String
    
    /// The name of the country.
    let name: Name
    
    /// The cities within the country.
    var cities = Set<City>()
    
    
    var dayCompleted = 0
    
    /// A Boolean value indicating whether all the cities in the country have non-zero balances.
    var isComplete: Bool {
        cities.allSatisfy(\.isComplete)
    }
    
    /// Creates a new `Country` instance.
    /// - Parameters:
    ///   - name: The name of the country.
    ///   - xRange: The range of valid X coordinates for cities in the country.
    ///   - yRange: The range of valid Y coordinates for cities in the country.
    init(name: String, xRange: ClosedRange<Int>, yRange: ClosedRange<Int>) {
        self.name = name
        
        for x in xRange {
            for y in yRange {
                let coordinates = Coordinates(x: x, y: y)
                let city = City(
                    coordinates: coordinates,
                    countryName: name
                )

                cities.insert(city)
            }
        }
    }
}

extension Country: Hashable, Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(cities)
    }
}

