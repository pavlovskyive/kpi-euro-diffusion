//
//  DiffusionCoder.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 10.04.2023.
//

import Foundation

struct DiffusionCoder {
    func decode(_ input: String) -> [DiffusionManager] {
        let lines = input.split(separator: "\n")
        var lineNumber = 0
        
        var diffusionManagers = [DiffusionManager]()
        
        while lines[lineNumber] != "0" {
            guard let countriesNumber = Int(lines[lineNumber]) else {
                return []
            }
            
            var countries = [Country]()
            
            for countryIndex in 1...countriesNumber {
                let parts = lines[lineNumber + countryIndex].split(separator: " ")
                
                let name = String(parts[0])
                guard
                    let minX = Int(parts[1]),
                    let minY = Int(parts[2]),
                    let maxX = Int(parts[3]),
                    let maxY = Int(parts[4])
                else {
                    return []
                }
                
                guard
                    [minX, minY].allSatisfy({ $0 > 0 }),
                    minX <= maxX,
                    minY <= maxY,
                    [maxX, maxY].allSatisfy({ $0 <= DiffusionConfig.gridSize })
                else {
                    return []
                }
                
                countries.append(
                    Country(name: name, xRange: minX...maxX, yRange: minY...maxY)
                )
            }
            
            diffusionManagers.append(DiffusionManager(countries: countries))
            
            lineNumber += countriesNumber + 1
        }
        
        return diffusionManagers
    }
    
    func encode(results: [[DiffusionManager.State]]) -> String {
        var resultingString = ""
        
        guard !results.isEmpty else {
            return ErrorStrings.invalidInput
        }

        for (caseNumber, result) in results.enumerated() {
            resultingString.append("Case number \(caseNumber + 1)\n")

            for (country, days) in result {
                resultingString.append("\(country.name) \(days)\n")
            }
        }
        
        return resultingString
    }
}
