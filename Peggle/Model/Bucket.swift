//
//  Bucket.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import Foundation

class Bucket: PeggleObject {
    private(set) var size: Double
    private enum CodingKeys: String, CodingKey {
        case size
    }
    init(size: Double = 130.0, coordinate: Point = .ZERO) {
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
    override func toPhysicsBody(_ initialVector: Vector?) -> PhysicsBody {
        BucketBody(velocity: Vector(x: 100), canMove: true, position: coordinate, height: size, width: size)
    }
}
