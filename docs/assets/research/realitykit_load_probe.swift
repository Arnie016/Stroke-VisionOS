import Foundation
import RealityKit

private func collectStats(_ root: Entity) -> (entities: Int, models: Int, meshes: Int, materials: Int) {
    var entities = 0
    var models = 0
    var meshes = 0
    var materials = 0

    func visit(_ entity: Entity) {
        entities += 1
        if let model = entity.components[ModelComponent.self] {
            models += 1
            meshes += 1
            materials += model.materials.count
        }
        for child in entity.children {
            visit(child)
        }
    }

    visit(root)
    return (entities, models, meshes, materials)
}

guard CommandLine.arguments.count == 2 else {
    fputs("usage: realitykit_load_probe <directory-containing-usdz>\n", stderr)
    exit(64)
}

let directory = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
let fileManager = FileManager.default
let files = try fileManager.contentsOfDirectory(
    at: directory,
    includingPropertiesForKeys: [.fileSizeKey],
    options: [.skipsHiddenFiles]
).filter { $0.pathExtension.lowercased() == "usdz" }
 .sorted { $0.lastPathComponent < $1.lastPathComponent }

var failures = 0
for file in files {
    let start = Date()
    do {
        let entity = try Entity.load(contentsOf: file)
        let elapsedMs = Date().timeIntervalSince(start) * 1_000
        let bounds = entity.visualBounds(relativeTo: nil)
        let dimensions = bounds.max - bounds.min
        let stats = collectStats(entity)
        let size = (try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
        print(
            String(
                format: "%@|PASS|bytes=%d|load_ms=%.1f|entities=%d|models=%d|meshes=%d|materials=%d|bounds_min=%.6f,%.6f,%.6f|bounds_max=%.6f,%.6f,%.6f|dimensions=%.6f,%.6f,%.6f",
                file.lastPathComponent,
                size,
                elapsedMs,
                stats.entities,
                stats.models,
                stats.meshes,
                stats.materials,
                bounds.min.x, bounds.min.y, bounds.min.z,
                bounds.max.x, bounds.max.y, bounds.max.z,
                dimensions.x, dimensions.y, dimensions.z
            )
        )
    } catch {
        failures += 1
        print("\(file.lastPathComponent)|FAIL|\(error)")
    }
}

exit(failures == 0 ? 0 : 1)
