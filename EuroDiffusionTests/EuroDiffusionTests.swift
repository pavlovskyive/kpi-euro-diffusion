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
        Case number 1
        France 1325
        Spain 382
        Portugal 416
        Case number 2
        Luxembourg 1
        Case number 3
        Netherlands 2
        Belgium 2
        
        """
        
        var output = ""
        
        let diffusionCoder = DiffusionCoder()
        let managers = diffusionCoder.decode(input)
        
        var results: [[DiffusionManager.State]] = Array(repeating: [DiffusionManager.State](), count: managers.count)

        for (index, manager) in managers.enumerated() {
            let result = manager.runSimulation()
            results[index] = result
        }

        output = diffusionCoder.encode(results: results)
        
        XCTAssertEqual(output, expectedOutput)
    }
}
