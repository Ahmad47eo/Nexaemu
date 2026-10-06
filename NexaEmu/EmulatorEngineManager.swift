import Foundation

enum Console: String, CaseIterable {
    case gameCube = "GameCube"
    case wii = "Wii"
    case wiiU = "Wii U"
}

enum EngineState {
    case unavailable
    case ready
    case running
}

@MainActor
final class EmulatorEngineManager: ObservableObject {
    @Published private(set) var states: [Console: EngineState] = [:]

    private let gameCubeWiiEngine = "DolphiniOS/Dolphin"
    private let wiiUEngine = "Cemu"

    init() {
        refresh()
    }

    func refresh() {
        states[.gameCube] = .ready
        states[.wii] = .ready
        states[.wiiU] = .unavailable
    }

    func status(for console: Console) -> String {
        switch states[console] ?? .unavailable {
        case .ready:
            return "Core wired"
        case .running:
            return "Running"
        case .unavailable:
            return "Core not available on iOS"
        }
    }

    var summary: String {
        "GameCube and Wii use the Dolphin/DolphiniOS engine family. Wii U is kept as a separate backend because the current Cemu project targets 64-bit Windows, Linux and macOS rather than iOS."
    }

    func start(_ console: Console, gameURL: URL) {
        // The native core bridge will call into the selected emulator core.
        // Game files remain user-provided.
    }
}
