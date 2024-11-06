//
//  ImagePicker.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 26..
//
import SwiftUI
import UIKit
import Vision
import Foundation

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage, let cgImage = uiImage.cgImage {
                parent.image = uiImage
                recognizeTextInImage(cgImage: cgImage) { lines in
                    let items = parseItems(from: lines)
                    for item in items {
                        print("Product: \(item.name), Price: \(item.price)")
                    }
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

func recognizeTextInImage(cgImage: CGImage, completion: @escaping ([String]) -> Void) {
    let request = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        let lines = observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
        print(lines)
        completion(lines)
    }
    
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    DispatchQueue.global(qos: .userInitiated).async {
        try? handler.perform([request])
    }
}

func parseItems(from lines: [String]) -> [(name: String, price: String)] {
    let pattern = #"(.+)\s+(\d+\.?\d*)$"#
    var items = [(name: String, price: String)]()
    
    for line in lines {
        if let match = line.range(of: pattern, options: .regularExpression) {
            let parts = line[match].components(separatedBy: " ")
            if parts.count >= 2 {
                let name = parts.dropLast().joined(separator: " ")
                let price = parts.last ?? ""
                items.append((name: name, price: price))
            }
        }
    }
    return items
}

