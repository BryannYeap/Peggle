import SwiftUI

@main
struct PeggleApp: App {

    @StateObject var savedLevels = SavedLevels(storageManager: StorageManager())
    let audioPlayer = AudioPlayer.initialiseAudioPlayer()

    var body: some Scene {
        WindowGroup {
            LoadLevelView(viewModel: LoadLevelViewModel(savedLevels: savedLevels), showMenuUponStartUp: true)
        }
    }
}
