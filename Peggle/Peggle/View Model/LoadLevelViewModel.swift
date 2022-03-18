import Foundation

class LoadLevelViewModel: ObservableObject {

    @Published private(set) var savedLevels: SavedLevels

    var getSavedCollectionOfLevels: [Level] {
        return savedLevels.savedLevels
    }

    init(savedLevels: SavedLevels = .init()) {
        self.savedLevels = savedLevels
    }

    func deleteLevel(at indexSet: IndexSet) {
        savedLevels.deleteLevel(at: indexSet)
    }

    func hasNoSavedLevels() -> Bool {
        getSavedCollectionOfLevels.isEmpty
    }

    func deleteAllLevels() {
        savedLevels.deleteAllLevels()
    }
}
