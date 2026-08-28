import Foundation
import CoreGraphics

/// Gallery and placed-image ink use the same fitted raster bounds, never the
/// surrounding letterbox. Normalized marks therefore survive resizing.
enum StrokeImagingImageFit {
    static func rect(image: CGSize, viewport: CGSize) -> CGRect {
        guard [image.width, image.height, viewport.width, viewport.height].allSatisfy({ $0.isFinite && $0 > 0 }) else { return .zero }
        let scale = min(viewport.width / image.width, viewport.height / image.height)
        let size = CGSize(width: image.width * scale, height: image.height * scale)
        let x = (viewport.width - size.width) / 2
        let y = (viewport.height - size.height) / 2
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
}

enum StrokeGalleryLayout: Int, CaseIterable, Identifiable {
    case two = 2, three = 3, four = 4
    var id: Int { rawValue }
    var capacity: Int { rawValue * rawValue }
    var title: String { "\(rawValue) × \(rawValue)" }
}

enum StrokeGalleryModality: String, CaseIterable, Identifiable {
    case ct = "CT", mri = "MRI", xray = "X-ray", unspecified = "Unspecified"
    var id: String { rawValue }
}

struct StrokeGalleryImage: Identifiable {
    let id: UUID
    let name: String
    var modality: StrokeGalleryModality
    let assetName: String?
    let data: Data?
    var strokes: [[CGPoint]] = []
    var isLocal: Bool { data != nil }

    init(name: String, modality: StrokeGalleryModality, assetName: String? = nil, data: Data? = nil) {
        id = UUID()
        self.name = String(name.prefix(72))
        self.modality = modality
        self.assetName = assetName
        self.data = data
    }
}

/// An ephemeral teaching lightbox, never a PACS, patient record, or scan analysis.
/// Grid capacity is not image count: missing cells never duplicate real scans.
struct StrokeImagingGalleryModel {
    static let maximumImageCount = 40
    static let maximumBytes = 64 * 1_024 * 1_024
    var layout: StrokeGalleryLayout = .two
    var filter: StrokeGalleryModality?
    var page = 0
    private(set) var pendingImport: UUID?
    private(set) var images: [StrokeGalleryImage] = [
        .init(name: "CT research atlas", modality: .ct, assetName: "StrokeCTTemplate"),
        .init(name: "MRI research atlas", modality: .mri, assetName: "StrokeMRITemplate")
    ]

    var filteredImages: [StrokeGalleryImage] {
        images.filter { filter == nil || $0.modality == filter }
    }
    var pageCount: Int { max(1, (filteredImages.count + layout.capacity - 1) / layout.capacity) }
    var visibleImages: [StrokeGalleryImage] {
        Array(filteredImages.dropFirst(min(max(0, page), pageCount - 1) * layout.capacity).prefix(layout.capacity))
    }
    var localBytes: Int { images.reduce(0) { $0 + ($1.data?.count ?? 0) } }

    mutating func beginImport() -> UUID {
        let request = UUID()
        pendingImport = request
        return request
    }
    mutating func cancelImport() { pendingImport = nil }

    /// Decoding/normalization happens before this boundary. A departed or newer
    /// gallery session cannot accept an old async result.
    mutating func completeImport(_ request: UUID, images incoming: [StrokeGalleryImage]) -> Int {
        guard pendingImport == request else { return 0 }
        pendingImport = nil
        var added = 0
        for image in incoming {
            guard images.count < Self.maximumImageCount,
                  let data = image.data, !data.isEmpty,
                  localBytes + data.count <= Self.maximumBytes else { continue }
            images.append(image)
            added += 1
        }
        filter = nil
        page = max(0, (images.count - 1) / layout.capacity)
        return added
    }

    mutating func remove(_ id: UUID) {
        images.removeAll { $0.id == id && $0.isLocal }
        page = min(page, pageCount - 1)
    }
    mutating func setModality(_ modality: StrokeGalleryModality, for id: UUID) {
        guard let index = images.firstIndex(where: { $0.id == id && $0.isLocal }) else { return }
        images[index].modality = modality
        page = min(max(0, page), pageCount - 1)
    }
    mutating func appendStroke(_ points: [CGPoint], to id: UUID) {
        guard let index = images.firstIndex(where: { $0.id == id }), points.count > 1,
              images[index].strokes.count < 80 else { return }
        let safe = points.prefix(1_000).filter { $0.x.isFinite && $0.y.isFinite }.map {
            CGPoint(x: min(1, max(0, $0.x)), y: min(1, max(0, $0.y)))
        }
        guard safe.count > 1 else { return }
        images[index].strokes.append(safe)
    }
    mutating func undoStroke(on id: UUID) {
        guard let index = images.firstIndex(where: { $0.id == id }), !images[index].strokes.isEmpty else { return }
        images[index].strokes.removeLast()
    }
    mutating func clearLocalImages() {
        cancelImport()
        images.removeAll(where: \.isLocal)
        for index in images.indices { images[index].strokes = [] }
        page = 0
        filter = nil
    }
}
