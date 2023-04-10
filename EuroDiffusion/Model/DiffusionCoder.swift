//
//  DiffusionCoder.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 10.04.2023.
//

import Foundation

/// A utility struct for decoding and encoding Euro Diffusion simulation input and output.
struct DiffusionCoder {
    
    /// Decodes the input string into an array of `DiffusionManager` objects, one for each case.
    ///
    /// - Parameter input: The input string.
    /// - Returns: An array of `DiffusionManager` objects.
    func decode(_ input: String) -> [DiffusionManager] {
        let lines = input.split(separator: "\n")
        var lineNumber = 0
        
        var diffusionManagers = [DiffusionManager]()
        
        while lines[lineNumber] != "0" {
            guard
                let countriesNumber = Int(lines[lineNumber]),
                1...DiffusionConfig.maxCountries ~= countriesNumber
            else {
                return []
            }
            
            var countries = [Country]()
            
            // Parse country data from input
            for countryIndex in 1...countriesNumber {
                let parts = lines[lineNumber + countryIndex].split(separator: " ")
                
                let name = String(parts[0])
                guard
                    let minX = Int(parts[safe: 1] ?? "0"),
                    let minY = Int(parts[safe: 2] ?? "0"),
                    let maxX = Int(parts[safe: 3] ?? "0"),
                    let maxY = Int(parts[safe: 4] ?? "0")
                else {
                    return []
                }
                
                // Validate country data
                guard
                    [minX, minY].allSatisfy({ $0 > 0 }),
                    minX <= maxX,
                    minY <= maxY,
                    [maxX, maxY].allSatisfy({ $0 <= DiffusionConfig.gridSize })
                else {
                    return []
                }
                
                // Add parsed country to array
                countries.append(
                    Country(name: name, xRange: minX...maxX, yRange: minY...maxY)
                )
            }
            
            // Create and add diffusion manager for parsed countries
            diffusionManagers.append(DiffusionManager(countries: countries))
            
            // Move to next line in input
            lineNumber += countriesNumber + 1
        }
        
        return diffusionManagers
    }
    
    /// Encodes the simulation results into a string.
    ///
    /// - Parameter results: A two-dimensional array of simulation results.
    /// - Returns: A string containing the encoded results.
    func encode(results: [[DiffusionManager.State]]) -> String {
        var resultingString = ""
        
        // Make sure results array is not empty (there were no errors in process)
        guard !results.isEmpty else {
            return ErrorStrings.invalidInput
        }

        // Append each case's results to the resulting string
        for (caseNumber, result) in results.enumerated() {
            resultingString.append("Case number \(caseNumber + 1)\n")

            // Append each country's results for the current case to the resulting string
            for (country, days) in result {
                resultingString.append("\(country.name) \(days)\n")
            }
        }
        
        return resultingString
    }
}
