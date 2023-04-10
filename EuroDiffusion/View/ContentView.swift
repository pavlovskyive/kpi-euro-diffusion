//
//  ContentView.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 21.03.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = EuroDiffusionViewModel()
    
    var body: some View {
        VStack {
            editViews
        }
        .navigationTitle("Euro Diffusion")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension ContentView {
    var editViews: some View {
        HStack(spacing: 16) {
            inputView
            processButton
            outputView
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var inputView: some View {
        EditView(
            text: $viewModel.input,
            actionItems: [
                ActionItem(
                    title: "Upload File",
                    icon: "doc.fill.badge.plus",
                    action: handleSelectFile
                ),
                ActionItem(
                    title: "Save Edited",
                    icon: "arrow.down.doc.fill"
                ) {
                    saveStringToFile(viewModel.input)
                }
            ]
        )
    }
    
    var outputView: some View {
        EditView(
            text: $viewModel.result,
            actionItems: [
                ActionItem(
                    title: "Save Result",
                    icon: "arrow.down.doc.fill"
                ) {
                    saveStringToFile(viewModel.result)
                }
            ]
        )
    }
    
    var processButton: some View {
        Button(action: handleCompute) {
            HStack(spacing: 5) {
                Text("Process")
                Image(systemName: "arrow.right")
            }
            .bold()
            .font(.system(size: 13, design: .monospaced))
            .foregroundColor(.white)
            .padding(.horizontal, 22)
            .padding(.vertical, 16)
            .background(.blue)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

private extension ContentView {
    func handleSelectFile() {
        let panel = NSOpenPanel()

        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        guard panel.runModal() == .OK else {
            return
        }
        
        processURL(panel.url)
    }
    
    func processURL(_ url: URL?) {
        guard
            let url,
            let contents = try? String(contentsOf: url, encoding: .utf8)
        else {
            return
        }
        
        viewModel.input = contents
    }
    
    func saveStringToFile(_ string: String) {
        let panel = NSSavePanel()
        panel.title = "Save Text File"
        panel.allowedFileTypes = ["txt"]
        panel.nameFieldStringValue = "Untitled.txt"

        guard panel.runModal() == .OK, let url = panel.url else {
            return
        }

        do {
            try string.write(to: url, atomically: true, encoding: .utf8)
            print("File saved successfully")
        } catch {
            print("Error saving file: \(error)")
        }
    }
    
    func handleCompute() {
        viewModel.processDiffusion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
