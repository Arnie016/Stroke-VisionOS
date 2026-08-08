import Foundation
import RealityKit

guard CommandLine.arguments.count == 2 else {
    fputs("usage: realitykit_animation_probe <animated-usdz>\n", stderr)
    exit(64)
}

let file = URL(fileURLWithPath: CommandLine.arguments[1])

do {
    let root = try Entity.load(contentsOf: file)
    var entities = 0
    var animationResources = 0

    func visit(_ entity: Entity) {
        entities += 1
        for animation in entity.availableAnimations {
            _ = animation
            animationResources += 1
        }
        for child in entity.children {
            visit(child)
        }
    }

    visit(root)
    print(
        String(
            format: "%@|PASS|entities=%d|animation_resources=%d",
            file.lastPathComponent,
            entities,
            animationResources
        )
    )
    exit(animationResources > 0 ? 0 : 2)
} catch {
    print("\(file.lastPathComponent)|FAIL|\(error)")
    exit(1)
}
