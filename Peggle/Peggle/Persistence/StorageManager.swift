import Foundation

class StorageManager {

    let savedLevelsUrl = FileManager().urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("savedLevels.json")
    let bundleUrl = Bundle.main.url(forResource: "Seed", withExtension: "json")

    func retrieveSavedLevels() -> [Level] {

        var url = savedLevelsUrl

        if let path = savedLevelsUrl?.path,
           !FileManager().fileExists(atPath: path) {
            url = bundleUrl
        }

        guard let url = url, let data = try? Data(contentsOf: url) else {
            fatalError("UNABLE TO DECODE DATA")
        }

        guard let savedLevels = try? JSONDecoder().decode([Level].self, from: data) else {
            fatalError("UNABLE TO DECODE JSON FROM DATA")
        }

        return savedLevels
    }

    func storeSavedLevels(_ levels: [Level]) {
        guard let savedLevelsJsonData = try? JSONEncoder().encode(levels) else {
            fatalError("UNABLE TO ENCODE DATA")
        }

        let savedLevelsJson = String(data: savedLevelsJsonData, encoding: .utf8)

        do {
            if let savedLevelsUrl = savedLevelsUrl {
                try savedLevelsJson?.write(to: savedLevelsUrl, atomically: true, encoding: .utf8)
            }
        } catch {
            print("UNABLE TO SAVE FILE TO DIRECTORY. \(error.localizedDescription)")
        }
    }
}
