import Foundation

class SavedLevels: ObservableObject {

    private let storageManager: StorageManager

    @Published private(set) var savedLevels: [Level]

    init(storageManager: StorageManager = StorageManager()) {
        self.storageManager = storageManager
        savedLevels = storageManager.retrieveSavedLevels()
    }

    func addLevel(level: Level) {
        savedLevels.append(level)
        saveLevels()
    }

    func saveLevels() {
        storageManager.storeSavedLevels(savedLevels)
    }

    func deleteLevel(at indexSet: IndexSet) {
        var mutatingIndexSet = indexSet
        for index in indexSet.reversed() {
            let level = savedLevels[index]
            if level.isPreloadedLevel {
                mutatingIndexSet.remove(index)
            }
        }
        savedLevels.remove(atOffsets: mutatingIndexSet)
        saveLevels()
    }

    func updateLevel(withOldName nameOfLevelToChange: String, level: Level) {
        if let index = savedLevels.firstIndex(where: { $0.id == nameOfLevelToChange }) {
            savedLevels[index] = level
            saveLevels()
        }
    }

    func hasLevelWithName(name: String) -> Bool {
        savedLevels.contains(where: { $0.id == name })
    }

    func deleteAllLevels() {
        deleteLevel(at: IndexSet(0 ..< savedLevels.count))
        saveLevels()
    }
}
