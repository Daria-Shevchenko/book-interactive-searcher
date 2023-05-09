//
//  AppViewModel.swift
//  dd
//
//  Created by Daria Shevchenko on 29.03.2023.
//

import AVKit
import Foundation
import SwiftUI
import VisionKit

@MainActor
final class AppViewModel: ObservableObject {
    @Published var dataScannerAccessStatus: StatusType = .notDetermined
    @Published var recornizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .text
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItems = true

    @Published var isVisable: Bool = true

    var recognizedDataType: DataScannerViewController.RecognizedDataType {
        .text(languages: ["en"], textContentType: textContentType)
    }

    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }

    var headerText: String {
        if recornizedItems.isEmpty {
            return "Scanning \(scanType.rawValue)"
        } else {
            return ""
        }
    }

    var dataScannerViewId: Int {
        var hsh = Hasher()
        hsh.combine(scanType)
        hsh.combine(recognizesMultipleItems)
        if let textContentType {
            hsh.combine(textContentType)
        }
        return hsh.finalize()
    }

    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .cameraNotAvailable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .cameraNotAvailable
        @unknown default:
            break
        }
    }
}
