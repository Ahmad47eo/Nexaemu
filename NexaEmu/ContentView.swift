import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, Color(red: 0.08, green: 0.08, blue: 0.12)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.white)

                    Text("NexaEmu")
                        .font(.system(size: 40, weight: .bold))

                    Text("GameCube • Wii • Wii U")
                        .foregroundStyle(.secondary)

                    Text("Emulator engine integration coming next.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.8))

                    HStack(spacing: 12) {
                        SystemCard(title: "GameCube", icon: "cube.fill")
                        SystemCard(title: "Wii", icon: "remote.fill")
                        SystemCard(title: "Wii U", icon: "gamecontroller")
                    }
                }
                .padding()
                .foregroundStyle(.white)
            }
            .navigationBarHidden(true)
        }
    }
}

private struct SystemCard: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }
}
