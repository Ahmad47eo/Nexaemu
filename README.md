# NexaEmu

NexaEmu is a SwiftUI frontend for user-provided GameCube and Wii game files.

## Current architecture

- SwiftUI library and RVZ file importer
- Persistent RVZ bookmarks
- GameCube/Wii engine target: DolphiniOS/Dolphin
- Wii U backend: not currently available on iOS
- GitHub Actions builds both the NexaEmu frontend and the DolphiniOS engine target

## Important

The current repository builds the two Xcode targets separately. The Dolphin C++ engine is not yet embedded as a framework inside the NexaEmu app. Therefore the NexaEmu Play button does not claim to run emulation until that native embedding boundary is completed.

Use only game files you are legally authorized to use. NexaEmu does not distribute games.


## Engine plan

NexaEmu targets the Fin/DolphiniOS/Dolphin architecture for GameCube and Wii. The current repository keeps the SwiftUI frontend and RVZ library separate from the native emulator integration until the native engine boundary is verified in CI. Wii U is intentionally deferred.
