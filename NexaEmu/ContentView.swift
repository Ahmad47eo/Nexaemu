import SwiftUI

struct ContentView: View {
    @StateObject private var engine = EmulatorEngineManager()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, Color(red: 0.06, green: 0.08, blue: 0.14)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NexaEmu")
                                .font(.system(size: 42, weight: .bold))
                            Text("One frontend • multiple emulator cores")
                                .foregroundStyle(.secondary)
                        }

                        HStack(spacing: 12) {
                            CoreCard(title: "GameCube", status: engine.status(for: .gameCube), icon: "cube.fill")
                            CoreCard(title: "Wii", status: engine.status(for: .wii), icon: "remote.fill")
                            CoreCard(title: "Wii U", status: engine.status(for: .wiiU), icon: "gamecontroller.fill")
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Label("Engine architecture", systemImage: "cpu")
                                .font(.headline)

                            Text(engine.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Button {
                                engine.refresh()
                            } label: {
                                Label("Check engine status", systemImage: "arrow.clockwise")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Game files")
                                .font(.headline)
                            Text("NexaEmu loads game files supplied by the user. It does not include copyrighted games.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .foregroundStyle(.white)
                }
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
            Text(status)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }
}
