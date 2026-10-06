import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var engine = EmulatorEngineManager()
    @State private var showingImporter = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.black, Color(red: 0.06, green: 0.08, blue: 0.14)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NexaEmu").font(.system(size: 42, weight: .bold))
                            Text("GameCube • Wii")
                                .foregroundStyle(.secondary)
                        }

                        HStack(spacing: 12) {
                            CoreCard(title: "GameCube", status: engine.status(for: .gameCube), icon: "cube.fill")
                            CoreCard(title: "Wii", status: engine.status(for: .wii), icon: "remote.fill")
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Label("Wii / RVZ Library", systemImage: "folder.fill")
                                .font(.headline)

                            if engine.games.isEmpty {
                                Text("Import your legally authorized .rvz Wii files from the Files app.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            } else {
                                ForEach(engine.games) { game in
                                    HStack {
                                        Image(systemName: "opticaldisc")
                                        VStack(alignment: .leading) {
                                            Text(game.name).lineLimit(1)
                                            Text("RVZ").font(.caption).foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Button("Play") {
                                            engine.start(.wii, gameURL: game.url)
                                        }
                                        .buttonStyle(.borderedProminent)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }

                            Button {
                                showingImporter = true
                            } label: {
                                Label("Import RVZ", systemImage: "plus.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))

                        VStack(alignment: .leading, spacing: 12) {
                            Label("Engine status", systemImage: "cpu").font(.headline)
                            Text(engine.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(engine.lastMessage)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Button {
                                engine.refresh()
                            } label: {
                                Label("Check engine status", systemImage: "arrow.clockwise")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))

                        Text("NexaEmu does not include or distribute copyrighted games. Imported files remain user-provided.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .foregroundStyle(.white)
                }
            }
            .fileImporter(isPresented: $showingImporter,
                          allowedContentTypes: [.rvz],
                          allowsMultipleSelection: true) { result in
                engine.importGames(result)
            }
        }
    }
}

private struct CoreCard: View {
    let title: String
    let status: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon).font(.title2)
            Text(title).font(.headline)
            Text(status).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }
}

private extension UTType {
    static let rvz = UTType(filenameExtension: "rvz") ?? UTType.data
}
