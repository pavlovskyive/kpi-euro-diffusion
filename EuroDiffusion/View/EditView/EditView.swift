//
//  EditView.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 22.03.2023.
//

import SwiftUI

struct EditView: View {
    @Binding var text: String
    var actionItems: [ActionItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            actionBar
            
            TextEditor(text: $text)
                .padding()
        }
        .background(.white)
        .cornerRadius(8)
        .font(.system(size: 16, design: .monospaced))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var actionBar: some View {
        HStack {
            ForEach(actionItems, id: \.title) { item in
                Button {
                    item.action()
                } label: {
                    Label(item.title, systemImage: item.icon)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(.white.opacity(0.2))
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
        }
        .font(.system(size: 12, design: .monospaced))
        .padding(8)
        .background(.blue)
    }
}
