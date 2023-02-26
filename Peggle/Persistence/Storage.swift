//
//  Storage.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 28/1/23.
//

import Foundation

class Storage {
    static let dataURL = FileManager()
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("data.json")
    static let seedURL = Bundle.main.url(forResource: "Seed", withExtension: "json")
    static func retrieveSavedLevels() -> [Level] {
        var url = dataURL
        if let path = dataURL?.path,
           !FileManager().fileExists(atPath: path) {
            url = seedURL
        }
        guard let url = url, let data = try? Data(contentsOf: url) else {
            fatalError("Could not get data")
        }
        guard let savedLevels = try? JSONDecoder().decode([Level].self, from: data) else {
            return [Level]()
        }
        return savedLevels
    }

    static func storeSavedLevels(_ levels: [Level]) {
        guard let jsonData = try? JSONEncoder().encode(levels) else {
            fatalError("Cannot encode data")
        }

        let savedLevelsJson = String(data: jsonData, encoding: .utf8)

        do {
            if let savedLevelsUrl = dataURL {
                try savedLevelsJson?.write(to: savedLevelsUrl, atomically: true, encoding: .utf8)
            }
        } catch {
            print("Unable to save data. \(error.localizedDescription)")
        }
    }
}
