//
//  EuroDiffusionViewModel.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 10.04.2023.
//

import SwiftUI
import Combine

/**
 A view model class for the Euro Diffusion app, responsible for processing input, running diffusion simulations and updating the result.
*/
class EuroDiffusionViewModel: ObservableObject {
    
    // MARK: Published Properties
    
    /// The result of the diffusion simulation as a string.
    @Published var result = "Here will be your result"
    
    /// The user's input for the diffusion simulation as a string.
    @Published var input = "Write your input here..."
    
    // MARK: Instance Properties
    
    /// An instance of `DiffusionCoder` used to encode and decode diffusion data.
    let diffusionCoder = DiffusionCoder()
    
    // MARK: Public Methods
    
    /// Processes the diffusion simulation based on the user's input.
    func processDiffusion() {
        
        // Decode the user's input into an array of `DiffusionManager`s.
        let managers = diffusionCoder.decode(input)
        guard !managers.isEmpty else {
            // If there was an error decoding the input, set the `result` property to an error message.
            result = ErrorStrings.invalidInput
            return
        }
        
        let group = DispatchGroup()
        var results = Array(repeating: [DiffusionManager.State](), count: managers.count)

        // Run simulation asynchronously for each `DiffusionManager` in the array.
        for (index, manager) in managers.enumerated() {
            group.enter()

            DispatchQueue.global().async {
                let result = manager.runSimulation()
                results[index] = result
                group.leave()
            }
        }

        // Wait for all simulations to finish.
        group.notify(queue: .main) { [weak self] in
            guard let owner = self else {
                return
            }

            // Encode the resulting states and update the `result` property.
            owner.result = owner.diffusionCoder.encode(results: results)
        }
    }
}
