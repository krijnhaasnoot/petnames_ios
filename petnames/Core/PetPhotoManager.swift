//
//  PetPhotoManager.swift
//  petnames
//
//  Petnames by Kinder - POC
//

import SwiftUI
import PhotosUI
@preconcurrency import Vision

/// Position for name text based on photo analysis
enum NamePosition: String, Codable, Sendable {
    case center  // Default when no photo
    case top     // Subject is in bottom half
    case bottom  // Subject is in top/center
}

/// Manages pet photo storage and retrieval
@MainActor
final class PetPhotoManager: ObservableObject {
    static let shared = PetPhotoManager()
    
    @Published var petImage: UIImage?
    @Published var namePosition: NamePosition = .center
    
    private let photoKey = "petnames_pet_photo"
    private let positionKey = "petnames_name_position"
    
    private init() {
        loadPhoto()
    }
    
    // MARK: - Load Photo
    
    private func loadPhoto() {
        guard let data = UserDefaults.standard.data(forKey: photoKey),
              let image = UIImage(data: data) else {
            return
        }
        petImage = image
        
        // Load cached position
        if let positionRaw = UserDefaults.standard.string(forKey: positionKey),
           let position = NamePosition(rawValue: positionRaw) {
            namePosition = position
        }
    }
    
    // MARK: - Save Photo
    
    func savePhoto(_ image: UIImage) {
        // Resize image to reasonable size (max 500x500)
        let resized = resizeImage(image, maxSize: 500)
        
        // Compress and save
        if let data = resized.jpegData(compressionQuality: 0.7) {
            UserDefaults.standard.set(data, forKey: photoKey)
            petImage = resized
            print("✅ Pet photo saved")
            
            // Track analytics
            AnalyticsManager.shared.trackPetPhotoUploaded()
            
            // Analyze photo for best text position
            Task {
                await analyzePhotoForTextPosition(resized)
            }
        }
    }
    
    // MARK: - Delete Photo
    
    func deletePhoto() {
        UserDefaults.standard.removeObject(forKey: photoKey)
        UserDefaults.standard.removeObject(forKey: positionKey)
        petImage = nil
        namePosition = .center
        print("🗑️ Pet photo deleted")
        
        // Track analytics
        AnalyticsManager.shared.trackPetPhotoRemoved()
    }
    
    // MARK: - Photo Analysis
    
    /// Analyzes the photo using Vision to find the main subject and determine best text position
    private func analyzePhotoForTextPosition(_ image: UIImage) async {
        guard let cgImage = image.cgImage else {
            setNamePosition(.bottom)
            return
        }
        
        // Perform Vision analysis on background thread
        let position = await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let result = Self.performSaliencyAnalysis(on: cgImage)
                continuation.resume(returning: result)
            }
        }
        
        setNamePosition(position)
        print("📍 Name position determined: \(position)")
    }
    
    /// Performs saliency analysis synchronously (called from background thread)
    private nonisolated static func performSaliencyAnalysis(on cgImage: CGImage) -> NamePosition {
        let request = VNGenerateAttentionBasedSaliencyImageRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
            
            guard let result = request.results?.first as? VNSaliencyImageObservation,
                  let salientObjects = result.salientObjects else {
                return .bottom
            }
            
            // Calculate weighted average Y position of salient objects
            let centerY = calculateAverageY(from: salientObjects)
            
            // Vision coordinates: (0,0) is bottom-left, (1,1) is top-right
            // If subject is in upper half (centerY > 0.5), put name at bottom
            // If subject is in lower half (centerY < 0.5), put name at top
            if centerY > 0.6 {
                return .bottom  // Subject is high, name goes low
            } else if centerY < 0.4 {
                return .top     // Subject is low, name goes high
            } else {
                return .bottom  // Subject is centered, default to bottom
            }
            
        } catch {
            print("⚠️ Vision request failed: \(error.localizedDescription)")
            return .bottom
        }
    }
    
    private nonisolated static func calculateAverageY(from objects: [VNRectangleObservation]) -> CGFloat {
        guard !objects.isEmpty else { return 0.5 }
        
        // Weight larger objects more heavily
        var weightedSum: CGFloat = 0
        var totalWeight: CGFloat = 0
        
        for obj in objects {
            let weight = obj.boundingBox.width * obj.boundingBox.height
            let centerY = obj.boundingBox.midY
            weightedSum += centerY * weight
            totalWeight += weight
        }
        
        return totalWeight > 0 ? weightedSum / totalWeight : 0.5
    }
    
    private func setNamePosition(_ position: NamePosition) {
        namePosition = position
        UserDefaults.standard.set(position.rawValue, forKey: positionKey)
    }
    
    // MARK: - Helpers
    
    private func resizeImage(_ image: UIImage, maxSize: CGFloat) -> UIImage {
        let size = image.size
        let ratio = min(maxSize / size.width, maxSize / size.height)
        
        if ratio >= 1 {
            return image
        }
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

// MARK: - Photo Picker View

struct PetPhotoPicker: View {
    @ObservedObject var photoManager = PetPhotoManager.shared
    @State private var selectedItem: PhotosPickerItem?
    @State private var showDeleteConfirm = false
    
    private var hasPhoto: Bool {
        photoManager.petImage != nil
    }
    
    private var buttonLabel: String {
        hasPhoto ? "Wijzigen" : "Foto kiezen"
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Current photo or placeholder
            ZStack {
                if let image = photoManager.petImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "667eea"), lineWidth: 3)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "667eea").opacity(0.1))
                        .frame(width: 120, height: 120)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color(hex: "667eea"))
                                Text("Geen foto")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "667eea").opacity(0.3), lineWidth: 2)
                        )
                }
            }
            
            // Buttons
            HStack(spacing: 12) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label(buttonLabel, systemImage: "photo.on.rectangle")
                        .font(.subheadline.weight(.medium))
                }
                .buttonStyle(.bordered)
                .tint(Color(hex: "667eea"))
                
                if hasPhoto {
                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Label("Verwijder", systemImage: "trash")
                            .font(.subheadline.weight(.medium))
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            Task { @MainActor in
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    photoManager.savePhoto(image)
                }
            }
        }
        .alert("Foto verwijderen?", isPresented: $showDeleteConfirm) {
            Button("Annuleren", role: .cancel) {}
            Button("Verwijderen", role: .destructive) {
                photoManager.deletePhoto()
            }
        } message: {
            Text("De foto van je huisdier wordt verwijderd van de naamkaartjes.")
        }
    }
}
