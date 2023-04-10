//
//  EuroDiffusionTests.swift
//  EuroDiffusionTests
//
//  Created by Vsevolod Pavlovskyi on 21.03.2023.
//

import XCTest
@testable import EuroDiffusion

final class EuroDiffusionTests: XCTestCase {
    func testWhole() {
        let input =
        """
        3
        France 1 4 4 6
        Spain 3 1 6 3
        Portugal 1 1 2 2
        1
        Luxembourg 1 1 1 1
        2
        Netherlands 1 3 2 4
        Belgium 1 1 2 2
        0
        """
        
        let expectedOutput =
        """
        Case Number 1
        Spain 382
        Portugal 416
        France 1325
        Case Number 2
        Luxembourg 0
        Case Number 3
        Belgium 2
        Netherlands 2
        """
        
        var output = ""
        
        let diffusionCoder = DiffusionCoder()
        let managers = diffusionCoder.decode(input)
        
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
        group.notify(queue: .main) {
            output = diffusionCoder.encode(results: results)
            
            XCTAssertEqual(output, expectedOutput)
        }
    }
}
