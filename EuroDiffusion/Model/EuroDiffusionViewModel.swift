//
//  EuroDiffusionViewModel.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 10.04.2023.
//

import SwiftUI
import Combine

class EuroDiffusionViewModel: ObservableObject {
    @Published var result = "Here will be your result"
    @Published var input = "Write your input here..."
    
    let diffusionCoder = DiffusionCoder()
    
    func processDiffusion() {
        let managers = diffusionCoder.decode(input)
        guard !managers.isEmpty else {
            result = ErrorStrings.invalidInput
            
            return
        }
        
        let group = DispatchGroup()
        var results: [[DiffusionManager.State]] = Array(repeating: [DiffusionManager.State](), count: managers.count)

        for (index, manager) in managers.enumerated() {
            group.enter()

            // Run simulation asynchronously
            DispatchQueue.global().async {
                let result = manager.runSimulation()
                results[index] = result
                group.leave()
            }
        }

        // Wait for all simulations to finish
        group.notify(queue: .main) { [weak self] in
            guard let owner = self else {
                return
            }

            owner.result = owner.diffusionCoder.encode(results: results)
        }
    }
}
