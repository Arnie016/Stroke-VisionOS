import SwiftUI
import UniformTypeIdentifiers
import ImageIO

/// A large spatial lightbox. Only real raster images enter the comparison grid;
/// conceptual CTA/MRA/PET diagrams stay in the separate study index.
struct StrokeImagingGalleryView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @State private var selectedID: UUID?
    @State private var importerVisible = false
    @State private var requestID: UUID?
    @State private var status: String?
    @State private var isMarking = false
    @State private var currentStroke: [CGPoint] = []

    private var selected: StrokeGalleryImage? {
        experience.imagingGallery.images.first { $0.id == selectedID }
    }

    var body: some View {
        VStack(spacing: 16) {
            if let selected {
                detail(selected)
            } else {
                gallery
            }
            HStack {
                Text(status ?? "Independent images · not registered · teaching use only")
                    .font(.caption).foregroundStyle(.white.opacity(0.64))
                Spacer()
                Text("\(experience.imagingGallery.images.count) / 40 images")
                    .font(.caption.monospacedDigit()).foregroundStyle(.cyan)
            }
        }
        .fileImporter(isPresented: $importerVisible, allowedContentTypes: [.image],
                      allowsMultipleSelection: true, onCompletion: importImages)
        .onAppear {
            if CommandLine.arguments.contains("--proof-imaging-gallery-detail"),
               let id = experience.imagingGallery.images.first?.id {
                selectedID = id
                experience.imagingGallery.appendStroke([CGPoint(x: 0.35, y: 0.45), CGPoint(x: 0.50, y: 0.38), CGPoint(x: 0.65, y: 0.45)], to: id)
            }
        }
        .onDisappear {
            experience.imagingGallery.cancelImport()
            requestID = nil
        }
    }

    private var gallery: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                ForEach(StrokeGalleryLayout.allCases) { layout in
                    Button(layout.title) {
                        experience.imagingGallery.layout = layout
                        experience.imagingGallery.page = 0
                    }
                    .buttonStyle(.bordered)
                    .tint(experience.imagingGallery.layout == layout ? .cyan : .gray)
                    .frame(minWidth: 92, minHeight: 52)
                    .accessibilityLabel("Compare in a \(layout.rawValue) by \(layout.rawValue) grid")
                }
                Menu {
                    Button("All images") { setFilter(nil) }
                    ForEach(StrokeGalleryModality.allCases) { modality in
                        Button(modality.rawValue) { setFilter(modality) }
                    }
                } label: {
                    Label(experience.imagingGallery.filter?.rawValue ?? "All images", systemImage: "line.3.horizontal.decrease")
                }.buttonStyle(.bordered)
                Spacer()
                Button("Add scans", systemImage: "photo.badge.plus") { beginImport() }
                    .buttonStyle(.borderedProminent).tint(.cyan)
                    .disabled(requestID != nil)
            }
            GeometryReader { geometry in
                let columns = experience.imagingGallery.layout.rawValue
                let gap: CGFloat = 12
                let height = (geometry.size.height - CGFloat(columns - 1) * gap) / CGFloat(columns)
                let images = experience.imagingGallery.visibleImages
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: gap), count: columns), spacing: gap) {
                    ForEach(0..<experience.imagingGallery.layout.capacity, id: \.self) { index in
                        if index < images.count {
                            tile(images[index], height: height)
                        } else {
                            Button { beginImport() } label: {
                                Image(systemName: "plus")
                                    .font(.title3).foregroundStyle(.white.opacity(0.35))
                                    .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
                                    .background(.white.opacity(0.025), in: RoundedRectangle(cornerRadius: 14))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.12), style: StrokeStyle(lineWidth: 1, dash: [5, 6])))
                            }.buttonStyle(.plain).hoverEffect(.highlight)
                                .accessibilityLabel("Empty comparison slot. Add de-identified images")
                                .disabled(requestID != nil)
                        }
                    }
                }
            }.frame(height: 480)
            HStack {
                Button("Previous", systemImage: "chevron.left") { experience.imagingGallery.page -= 1 }
                    .disabled(experience.imagingGallery.page == 0)
                Spacer()
                Text("Page \(experience.imagingGallery.page + 1) of \(experience.imagingGallery.pageCount)")
                    .font(.callout.monospacedDigit())
                Spacer()
                Button("Next", systemImage: "chevron.right") { experience.imagingGallery.page += 1 }
                    .disabled(experience.imagingGallery.page + 1 >= experience.imagingGallery.pageCount)
            }.buttonStyle(.bordered)
        }
    }

    private func tile(_ item: StrokeGalleryImage, height: CGFloat) -> some View {
        Button {
            selectedID = item.id
            isMarking = false
            currentStroke = []
        } label: {
            VStack(spacing: 4) {
                if let image = uiImage(item) {
                    Image(uiImage: image).resizable().scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                HStack {
                    Text(item.modality.rawValue).font(.caption.weight(.bold)).foregroundStyle(.cyan)
                    Text(item.name).font(.caption).lineLimit(1)
                    Spacer(minLength: 0)
                    if !item.strokes.isEmpty { Image(systemName: "pencil.tip.crop.circle").foregroundStyle(.orange) }
                }
            }
            .padding(8).frame(maxWidth: .infinity).frame(height: height)
            .background(.black, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.20)))
        }.buttonStyle(.plain).hoverEffect(.highlight)
            .accessibilityLabel("Open \(item.modality.rawValue), \(item.name)")
    }

    private func detail(_ item: StrokeGalleryImage) -> some View {
        VStack(spacing: 12) {
            HStack {
                Button("Gallery", systemImage: "chevron.left") {
                    selectedID = nil
                    isMarking = false
                    currentStroke = []
                }.buttonStyle(.bordered)
                Text(item.name).font(.title3.weight(.semibold)).lineLimit(1)
                Spacer()
                if item.isLocal {
                    Menu {
                        ForEach(StrokeGalleryModality.allCases) { modality in
                            Button(modality.rawValue) { experience.imagingGallery.setModality(modality, for: item.id) }
                        }
                    } label: { Text(item.modality.rawValue) }.buttonStyle(.bordered)
                    Button("Remove", systemImage: "trash") {
                        experience.imagingGallery.remove(item.id)
                        selectedID = nil
                        currentStroke = []
                    }.buttonStyle(.bordered)
                }
            }
            if let image = uiImage(item) {
                GeometryReader { geometry in
                    let size = StrokeImagingImageFit.rect(image: image.size, viewport: geometry.size).size
                    ZStack {
                        Image(uiImage: image).resizable().scaledToFit()
                        Canvas { context, canvasSize in
                            for points in item.strokes + (currentStroke.isEmpty ? [] : [currentStroke]) {
                                var path = Path()
                                for (index, point) in points.enumerated() {
                                    let destination = CGPoint(x: point.x * canvasSize.width, y: point.y * canvasSize.height)
                                    if index == 0 { path.move(to: destination) } else { path.addLine(to: destination) }
                                }
                                context.stroke(path, with: .color(.orange), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                            }
                        }.allowsHitTesting(false)
                    }
                    .frame(width: size.width, height: size.height)
                    .contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0).onChanged { value in
                        guard isMarking, currentStroke.count < 1_000 else { return }
                        currentStroke.append(CGPoint(x: min(1, max(0, value.location.x / size.width)),
                                                     y: min(1, max(0, value.location.y / size.height))))
                    }.onEnded { _ in
                        if isMarking { experience.imagingGallery.appendStroke(currentStroke, to: item.id) }
                        currentStroke = []
                    }, including: isMarking ? .all : .none)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }.frame(height: 480).background(.black, in: RoundedRectangle(cornerRadius: 18))
            }
            HStack {
                Button(isMarking ? "Done" : "Annotate", systemImage: isMarking ? "checkmark" : "pencil.tip.crop.circle") {
                    isMarking.toggle()
                    currentStroke = []
                }.buttonStyle(.borderedProminent).tint(isMarking ? .orange : .cyan)
                Button("Undo", systemImage: "arrow.uturn.backward") { experience.imagingGallery.undoStroke(on: item.id) }
                    .buttonStyle(.bordered).disabled(item.strokes.isEmpty)
                Button("Place beside brain", systemImage: "rectangle.on.rectangle.angled") {
                    if !currentStroke.isEmpty { experience.imagingGallery.appendStroke(currentStroke, to: item.id) }
                    currentStroke = []
                    if experience.placeImagingGalleryImage(item.id) {
                        isMarking = false
                    } else {
                        status = "This image could not be placed. It is still available in the gallery."
                    }
                }.buttonStyle(.bordered).tint(.cyan)
                    .accessibilityHint("Keeps this image and its marks on one movable plate. Other temporary gallery images clear on leaving")
                Spacer()
                Text(item.isLocal ? "Only this image travels · other imports clear on leaving"
                     : "Kaffenberger et al. · CC BY 4.0 · research atlas")
                    .font(.caption).foregroundStyle(.white.opacity(0.64))
            }
        }
    }

    private func uiImage(_ item: StrokeGalleryImage) -> UIImage? {
        if let data = item.data { return UIImage(data: data) }
        return item.assetName.flatMap { UIImage(named: $0) }
    }

    private func setFilter(_ filter: StrokeGalleryModality?) {
        experience.imagingGallery.filter = filter
        experience.imagingGallery.page = 0
    }

    private func beginImport() {
        guard requestID == nil else { return }
        requestID = experience.imagingGallery.beginImport()
        status = "Select de-identified PNG, JPEG or HEIC images. No uploads."
        importerVisible = true
    }

    private func importImages(_ result: Result<[URL], Error>) {
        guard let request = requestID else { return }
        guard case .success(let urls) = result else {
            experience.imagingGallery.cancelImport()
            requestID = nil
            status = nil
            return
        }
        status = "Loading selected images…"
        Task { @MainActor in
            let imported = await Task.detached(priority: .userInitiated) {
                urls.prefix(40).compactMap { url -> StrokeGalleryImage? in
                    let access = url.startAccessingSecurityScopedResource()
                    defer { if access { url.stopAccessingSecurityScopedResource() } }
                    guard let count = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize,
                          count > 0, count <= 24 * 1_024 * 1_024,
                          let source = CGImageSourceCreateWithURL(url as CFURL, nil),
                          let thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, [
                            kCGImageSourceCreateThumbnailFromImageAlways: true,
                            kCGImageSourceCreateThumbnailWithTransform: true,
                            kCGImageSourceThumbnailMaxPixelSize: 1_536
                          ] as CFDictionary),
                          let data = UIImage(cgImage: thumbnail).jpegData(compressionQuality: 0.9) else { return nil }
                    return StrokeGalleryImage(name: url.lastPathComponent, modality: .unspecified, data: data)
                }
            }.value
            guard experience.focusedReferenceWorkspace == .imagingGallery,
                  experience.imagingGallery.pendingImport == request else { return }
            let added = experience.imagingGallery.completeImport(request, images: imported)
            requestID = nil
            let skipped = urls.count - added
            status = "Added \(added) image\(added == 1 ? "" : "s")." + (skipped > 0 ? " \(skipped) unreadable or over the gallery limit." : " Memory only. No uploads.")
        }
    }
}
