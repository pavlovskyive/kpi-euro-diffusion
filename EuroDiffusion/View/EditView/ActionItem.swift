//
//  ActionItem.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 22.03.2023.
//

import Foundation

struct ActionItem {
    let title: String
    let icon: String
    let action: () -> Void
}
