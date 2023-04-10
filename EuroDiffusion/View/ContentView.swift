//
//  ContentView.swift
//  EuroDiffusion
//
//  Created by Vsevolod Pavlovskyi on 21.03.2023.
//

import SwiftUI

/// A view that displays the Euro Diffusion application's user interface.
struct ContentView: View {
    @ObservedObject var viewModel = EuroDiffusionViewModel()
    
    /// The view's body that displays a vertical stack of the edit views.
    var body: some View {
        VStack {
            editViews
        }
        .navigationTitle("Euro Diffusion")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private extension ContentView {
    /**
    The view that displays the input view, the process button,
    and the output view in a horizontal stack.
    */
    var editViews: some View {
        HStack(spacing: 16) {
            inputView
            processButton
            outputView
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    /// The view that displays the input text area and its associated buttons.
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
    
    /// The view that displays the output text area and its associated buttons.
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
    
    /// The view that displays the "Process" button that starts the simulation.
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
    /// Handles the selection of a file by opening a file selector dialog.
    func handleSelectFile() {
        let panel = NSOpenPanel()

        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        guard panel.runModal() == .OK else {
            return
        }
        
        processURL(panel.url)
    }
    
    /// Handles url that contains the path for the input file's location.
    func processURL(_ url: URL?) {
        guard
            let url,
            let contents = try? String(contentsOf: url, encoding: .utf8)
        else {
            return
        }
        
        viewModel.input = contents
    }
    
    /// Initiates system's dialogue to save string as .txt file.
    func saveStringToFile(_ string: String) {
        let panel = NSSavePanel()
        panel.title = "Save Text File"
        panel.allowedContentTypes = [.plainText]
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
    
    /// Commands viewModel to run the simulation of diffusion with the given input.
    func handleCompute() {
        viewModel.processDiffusion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
