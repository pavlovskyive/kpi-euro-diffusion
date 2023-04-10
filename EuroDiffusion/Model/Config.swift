//
//  Config.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 10.04.2023.
//

import Foundation

/// A configuration object for the diffusion simulation.
struct DiffusionConfig {
    
    /// The initial balance for each city in a country.
    static let initialBalance = 1_000_000
    
    /// The portion of balance each city can transfer to its neighbors in each iteration.
    static let representativePortion = 1_000
    
    /// The grid size to use for organizing the cities.
    static let gridSize = 10
    
    /// Largest count of countries.
    static let maxCountries = 20
}

