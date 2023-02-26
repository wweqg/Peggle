//
//  savedLevels.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 23/1/23.
//

import Foundation

class SavedLevels: Codable {
    private(set) var levels: [Level]
    private enum CodingKeys: String, CodingKey {
        case levels
    }
    init(levels: [Level] = Storage.retrieveSavedLevels()) {
        self.levels = levels
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        levels = try container.decode([Level].self, forKey: .levels)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(levels, forKey: .levels)
    }
    func save() {
        Storage.storeSavedLevels(levels)
    }
    func append(level: Level) {
        levels.append(level)
    }
    func contains(level: Level) -> Bool {
        levels.contains(where: { $0 == level })
    }
    func delete(level: Level) {
        levels.removeAll(where: { $0 == level })
    }
    func copySelectedLevel(_ template: Level) {
        if let index = levels.firstIndex(of: template) {
            levels[index].copy(level: template)
        }
    }

}
