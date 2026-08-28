import Foundation
import CoreGraphics

@main struct GalleryChecks {
    static func main() {
        var count = 0
        func check(_ condition: Bool, _ message: String) {
            precondition(condition, message)
            count += 1
        }
        var gallery = StrokeImagingGalleryModel()
        check(gallery.images.count == 2, "Only two real bundled images")
        check(gallery.visibleImages.count == 2, "Do not fill grid with duplicate scans")
        check(StrokeGalleryLayout.two.capacity == 4, "2 by 2")
        check(StrokeGalleryLayout.three.capacity == 9, "3 by 3")
        check(StrokeGalleryLayout.four.capacity == 16, "4 by 4")
        let old = gallery.beginImport()
        gallery.cancelImport()
        let image = StrokeGalleryImage(name: "Test fixture", modality: .unspecified, data: Data([1, 2, 3]))
        check(gallery.completeImport(old, images: [image]) == 0, "Back rejects late results")
        let first = gallery.beginImport()
        let latest = gallery.beginImport()
        check(gallery.completeImport(first, images: [image]) == 0, "New request wins")
        check(gallery.pendingImport == latest, "Old completion preserves current request")
        check(gallery.completeImport(latest, images: [image]) == 1, "Current result accepted")
        check(gallery.completeImport(latest, images: [image]) == 0, "Consumed only once")
        let importID = gallery.images.last!.id
        gallery.setModality(.xray, for: importID)
        gallery.filter = .xray
        check(gallery.filteredImages.count == 1, "Modality is user selected")
        gallery.appendStroke([CGPoint(x: -1, y: 0.5), CGPoint(x: 0.6, y: 2)], to: importID)
        let clamped = gallery.images.last!.strokes[0]
        check(clamped.count == 2 && clamped[0].x == 0 && clamped[0].y == 0.5 && clamped[1].x == 0.6 && clamped[1].y == 1,
              "Ink clamped to image surface")
        check(gallery.images.first!.strokes.isEmpty, "Marks never leak to other images")
        gallery.undoStroke(on: importID)
        check(gallery.images.last!.strokes.isEmpty, "Undo affects selected image")
        gallery.remove(gallery.images.first!.id)
        check(gallery.images.count == 3, "Bundled atlas cannot be removed")
        gallery.remove(importID)
        check(gallery.images.count == 2, "Local image can be removed")
        gallery.filter = nil
        let batch = (0..<50).map { StrokeGalleryImage(name: "Fixture \($0)", modality: .unspecified, data: Data([1])) }
        let batchID = gallery.beginImport()
        check(gallery.completeImport(batchID, images: batch) == 38, "40 image limit includes atlas")
        gallery.layout = .four
        gallery.page = 1
        check(gallery.visibleImages.count == 16, "Second page has sixteen independent images")
        check(gallery.pageCount == 3, "Forty images use three 4 by 4 pages")
        gallery.page = 100
        check(gallery.visibleImages.count == 8, "Out of range page clamps safely")
        gallery.clearLocalImages()
        check(gallery.images.count == 2 && gallery.page == 0, "Exit releases imports and resets navigation")
        var filteredGallery = StrokeImagingGalleryModel()
        let filteredBatch = (0..<5).map { StrokeGalleryImage(name: "Filtered fixture \($0)", modality: .xray, data: Data([1])) }
        let filteredRequest = filteredGallery.beginImport()
        _ = filteredGallery.completeImport(filteredRequest, images: filteredBatch)
        filteredGallery.filter = .xray
        filteredGallery.page = 1
        filteredGallery.setModality(.mri, for: filteredBatch.last!.id)
        check(filteredGallery.page == 0 && filteredGallery.pageCount == 1,
              "Relabelling the final filtered image cannot leave an empty or misnumbered page")
        let large = StrokeGalleryImage(name: "Too large", modality: .unspecified,
                                      data: Data(repeating: 0, count: StrokeImagingGalleryModel.maximumBytes + 1))
        let largeID = gallery.beginImport()
        check(gallery.completeImport(largeID, images: [large]) == 0, "Aggregate memory cap")
        let square = StrokeImagingImageFit.rect(image: CGSize(width: 800, height: 800), viewport: CGSize(width: 900, height: 480))
        check(square == CGRect(x: 210, y: 0, width: 480, height: 480), "Square raster excludes side letterboxes")
        let wide = StrokeImagingImageFit.rect(image: CGSize(width: 1_600, height: 800), viewport: CGSize(width: 600, height: 500))
        check(wide == CGRect(x: 0, y: 100, width: 600, height: 300), "Landscape raster excludes top letterboxes")
        let tall = StrokeImagingImageFit.rect(image: CGSize(width: 400, height: 800), viewport: CGSize(width: 900, height: 480))
        check(tall == CGRect(x: 330, y: 0, width: 240, height: 480), "Portrait raster stays centered")
        check(StrokeImagingImageFit.rect(image: .zero, viewport: CGSize(width: 100, height: 100)) == .zero, "Invalid raster has no annotation area")
        check(StrokeImagingImageFit.rect(image: CGSize(width: 100, height: 100), viewport: CGSize(width: -1, height: 100)) == .zero,
              "Invalid viewport has no annotation area")
        check(StrokeImagingImageFit.rect(image: CGSize(width: CGFloat.nan, height: 100), viewport: CGSize(width: 100, height: 100)) == .zero,
              "Nonfinite dimensions are rejected")
        let larger = StrokeImagingImageFit.rect(image: CGSize(width: 800, height: 800), viewport: CGSize(width: 1_800, height: 960))
        check(larger.width == square.width * 2 && larger.minX == square.minX * 2, "Resize keeps marks in the same normalized raster coordinates")
        print("IMAGING_GALLERY=PASS checks=\(count)")
    }
}
