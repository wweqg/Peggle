//
//  Cannon.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import Foundation

class Cannon: PeggleObject {
    private(set) var size: Double
    var shoot = false
    private enum CodingKeys: String, CodingKey {
        case size
    }
    init(size: Double = 100.0, coordinate: Point = .ZERO) {
        self.size = size
        super.init(coordinate: coordinate)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        size = try container.decode(Double.self, forKey: .size)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(size, forKey: .size)
        try super.encode(to: encoder)
    }
}
