//
//  DiffusionManager.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 10.04.2023.
//

import Foundation

/// Manages the diffusion simulation across cities in multiple countries.
class DiffusionManager {
    /// A tupple that stores the diffusion state for each country.
    typealias State = (Country, Int)
    
    /// The current diffusion state.
    var state: [State]
    
    /// The set of countries being simulated.
    var countries = Set<Country>()
    
    /// The set of cities in all countries.
    var cities = Set<City>()
    
    /// A Boolean value indicating whether the simulation has completed for all countries.
    var isComplete: Bool {
        countries.allSatisfy(\.isComplete)
    }
    
    /// Initializes a new `DiffusionManager` instance with the given countries.
    /// - Parameter countries: An array of `Country` instances to simulate.
    init(countries: [Country]) {
        self.countries = Set(countries)
        self.cities = Set(countries.flatMap(\.cities))

        self.state = countries
            .reduce(into: [State]()) { result, current in
                result.append((current, -1))
            }
        
        assignCityBalances()
        assignCityNeighbours()
    }
    
    /// Assigns initial balances to all cities in all countries.
    func assignCityBalances() {
        for city in cities {
            city.balances = countries
                .reduce(into: [Country.Name: Int]()) { result, country in
                    guard city.countryName == country.name else {
                        result[country.name] = 0
                        
                        return
                    }
                    
                    result[country.name] = DiffusionConfig.initialBalance
                }
        }
    }
    
    /// Assigns neighbouring cities to all cities in all countries.
    func assignCityNeighbours() {
        var grid: [[City?]] = Array(
            repeating: Array(repeating: nil, count: DiffusionConfig.gridSize),
            count: DiffusionConfig.gridSize
        )
        
        cities.forEach { city in
            grid[city.coordinates.y - 1][city.coordinates.x - 1] = city
        }
        
        for city in cities {
            let x = city.coordinates.x - 1
            let y = city.coordinates.y - 1
            
            let possibleNeighbours = [
                grid[safe: y - 1]?[safe: x],
                grid[safe: y]?[safe: x - 1],
                grid[safe: y + 1]?[safe: x],
                grid[safe: y]?[safe: x + 1]
            ]
            
            city.neighbours = Set(possibleNeighbours.compactMap { $0 ?? nil })
        }
    }
    
    /// Performs a single iteration of the diffusion simulation.
    func diffuse() {
        for city in cities {
            for balance in city.balances {
                let transferAmount = Int(balance.value / DiffusionConfig.representativePortion)
                let wholeAmount = transferAmount * city.neighbours.count
                
                guard transferAmount > 0, wholeAmount <= balance.value else {
                    continue
                }
                
                city.balances[balance.key, default: 0] -= wholeAmount
                
                for neighbour in city.neighbours {
                    neighbour.cachedBalances[balance.key, default: 0] += transferAmount
                }
            }
        }
        
        for city in cities {
            city.updateBalances()
        }
    }
    
    /// Runs the diffusion simulation until all countries have reached a complete state.
    /// - Returns: A `Result` dictionary indicating the number of iterations it took for each country to reach a complete state.
    func runSimulation() -> [State] {
        var iterator = 0
        
        guard countries.count > 1 else {
            if let first = countries.first {
                return [(first, 1)]
            }
            
            return []
        }
        
        while !isComplete && iterator <= 10_000 { // Resolve stuck loop.
            diffuse()
            iterator += 1
            
            for index in state.indices {
                if state[index].0.isComplete && state[index].1 == -1 {
                    state[index].1 = iterator
                }
            }
        }
        
        return state
    }
}
