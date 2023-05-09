//
//  ARViewContainer.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 03.05.2023.
//

import Foundation
import RealityKit

import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var viewModel: ARViewModel
    @EnvironmentObject var rViewModel: RecommendationsViewModel

    @State var viewId = UUID()

    func recreateView() {
        viewId = UUID()
    }

    func makeUIView(context: Context) -> ARView {
        return ARView(frame: .zero)
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        updateBook(uiView: uiView)
    }

    private func updateBook(uiView: ARView) {
        uiView.scene.anchors.removeAll()

        let anchor = AnchorEntity()

        var text = MeshResource.generateText("Please scan again", extrusionDepth: 0.001, font: .systemFont(ofSize: 0.05, weight: .bold))
        if let last = viewModel.booksScanned.last {
            text = MeshResource.generateText(
                """
                Title: \(last.title)
                Author: \(last.author)
                Average price: \(last.price)
                Recommendation: \(statusRecommendation(for: last))")
                """,
                extrusionDepth: 0.001,
                font: .systemFont(ofSize: 0.05, weight: .bold)
            )
        }

        let color: UIColor = .black

        let shader = SimpleMaterial(color: color, roughness: 4, isMetallic: true)
        let textEntity = ModelEntity(mesh: text, materials: [shader])

        textEntity.position.z -= 4
        textEntity.setParent(anchor)
        uiView.scene.addAnchor(anchor)
    }

    func statusRecommendation(for book: Book) -> String {
        if rViewModel.booksRecomendations.contains(where: { $0.title == book.title }) {
            return "Really good!"
        } else {
            return "Try to search another."
        }
    }
}
