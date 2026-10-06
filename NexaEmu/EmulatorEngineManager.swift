import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct RVZGame: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let bookmark: Data

    init(id: UUID = UUID(), name: String, bookmark: Data) {
        self.id = id
        self.name = name
        self.bookmark = bookmark
    }

    var url: URL? {
        var stale = false
        return try? URL(resolvingBookmarkData: bookmark, options: [.withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &stale)
    }
}

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
    @Published private(set) var games: [RVZGame] = []
    @Published private(set) var lastMessage = "DolphiniOS native bridge is the remaining engine integration step."

    private let gameCubeWiiEngine = "DolphiniOS"
    private let wiiUEngine = "Cemu"

    init() {
        refresh()
        loadGames()
    }

    func refresh() {
        // These are integration targets, not claims that the native cores are linked.
        states[.gameCube] = .ready
        states[.wii] = .ready
        states[.wiiU] = .unavailable
    }

    func status(for console: Console) -> String {
        switch states[console] ?? .unavailable {
        case .ready:
            return console == .wiiU ? "Unavailable on iOS" : "Dolphin target"
        case .running:
            return "Running"
        case .unavailable:
            return "Unavailable"
        }
    }

    var summary: String {
        "GameCube and Wii are targeted at the DolphiniOS/Dolphin native core. Wii U remains unavailable because Cemu is not an iOS backend."
    }

    func importGames(_ result: Result<[URL], Error>) {
        switch result {
        case .failure(let error):
            lastMessage = "Import failed: \(error.localizedDescription)"
        case .success(let urls):
            var imported = 0
            for url in urls where url.pathExtension.lowercased() == "rvz" {
                do {
                    let bookmark = try url.bookmarkData(options: [.withSecurityScope], includingResourceValuesForKeys: nil, relativeTo: nil)
                    let game = RVZGame(name: url.deletingPathExtension().lastPathComponent, bookmark: bookmark)
                    if !games.contains(where: { $0.name == game.name }) {
                        games.append(game)
                        imported += 1
                    }
                } catch {
                    lastMessage = "Could not save access to \(url.lastPathComponent)."
                }
            }
            saveGames()
            lastMessage = imported == 0 ? "No new RVZ files imported." : "Imported \(imported) RVZ game(s)."
        }
    }

    func start(_ console: Console, gameURL: URL) {
        guard console == .gameCube || console == .wii else {
            lastMessage = "Wii U has no iOS engine connected."
            return
        }

        guard gameURL.startAccessingSecurityScopedResource() else {
            lastMessage = "NexaEmu could not access the selected game file."
            return
        }
        defer { gameURL.stopAccessingSecurityScopedResource() }

        states[console] = .running
        // TODO: Replace this state transition with the Objective-C++/Dolphin
        // boot bridge once the DolphiniOS Xcode target is linked into NexaEmu.
        lastMessage = "RVZ is ready for the DolphiniOS boot bridge."
    }

    private func saveGames() {
        if let data = try? JSONEncoder().encode(games) {
            UserDefaults.standard.set(data, forKey: "nexaemu.rvz.games")
        }
    }

    private func loadGames() {
        guard let data = UserDefaults.standard.data(forKey: "nexaemu.rvz.games"),
              let saved = try? JSONDecoder().decode([RVZGame].self, from: data) else { return }
        games = saved
    }
}
