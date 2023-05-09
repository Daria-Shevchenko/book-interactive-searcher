//
//  DataScannerView.swift
//  dd
//
//  Created by Daria Shevchenko on 29.03.2023.
//

import Foundation
import SwiftUI
import VisionKit

struct ScannerView: View {
    var onTap: () -> Void

    @EnvironmentObject var aViewModel: AppViewModel
    @EnvironmentObject var viewModel: ARViewModel

    @State private var transcriptText: String = ""

    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("All", .none)
    ]

    var body: some View {
        switch aViewModel.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        case .cameraNotAvailable:
            Text("Rou do not have a camera")
        case .scannerNotAvailable:
            Text("You cannot use camera")
        case .cameraAccessNotGranted:
            Text("Camera access not granted")
        case .notDetermined:
            Text("Requesting camera access")
        }
    }

    private var mainView: some View {
        ZStack {
            if aViewModel.isVisable {
                DataScannerView(
                    recognizedItems: $aViewModel.recornizedItems,
                    recognizedDataType: aViewModel.recognizedDataType,
                    recognizesMultipleItems: aViewModel.recognizesMultipleItems
                )
                .background { Color.gray.opacity(0.3) }
                .ignoresSafeArea()
                .id(aViewModel.dataScannerViewId)
                .sheet(isPresented: .constant(true)) {
                    bottomContainerView
                        .background(.ultraThinMaterial)
                        .presentationDetents([.medium, .fraction(0.25)])
                        .presentationDragIndicator(.visible)
                        .interactiveDismissDisabled()
                }
                .onChange(of: aViewModel.scanType) { _ in aViewModel.recornizedItems = [] }
                .onChange(of: aViewModel.textContentType) { _ in aViewModel.recornizedItems = [] }
                .onChange(of: aViewModel.recognizesMultipleItems) { _ in aViewModel.recornizedItems = [] }
            }
        }
    }

    private var headerView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("BOOKS:").font(.subheadline).padding(.top, 20).fontWeight(.bold)
            Text(aViewModel.headerText).font(.caption)
        }
    }

    private var bottomContainerView: some View {
        VStack(alignment: .leading) {
            headerView.padding(.leading, 20)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(aViewModel.recornizedItems) { item in
                        switch item {
                        case .text(let text):
                            Text(text.transcript)
                                .onAppear { transcriptText = text.transcript }
                        case .barcode:
                            Text("unknown")
                        @unknown default:
                            Text("unknown")
                        }
                    }
                }
                .padding()
            }
            continueButton
        }
    }

    @ViewBuilder
    var continueButton: some View {
        Button(action: {
            viewModel.scannedText = transcriptText
            viewModel.updateInfo()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                onTap()
                aViewModel.isVisable = false
            }

        }) {
            Text("Continue")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 60)
                .padding(.vertical, 10)
                .background(Color.black)
                .cornerRadius(30)
        }
        .padding([.bottom, .leading], 20)
    }
}
