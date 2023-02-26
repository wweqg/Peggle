//
//  CannonBall.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import Foundation

class CannonBall: PeggleObject {
    private(set) var radius: Double
    private enum CodingKeys: String, CodingKey {
        case radius
    }
    init(radius: Double = 20.0, coordinate: Point = .ZERO) {
        self.radius = radius
        super.init(coordinate: coordinate)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        radius = try container.decode(Double.self, forKey: .radius)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(radius, forKey: .radius)
        try super.encode(to: encoder)
    }
    override func toPhysicsBody(_ initialVector: Vector?) -> PhysicsBody {
        guard let vector = initialVector else {
            fatalError("Initial Velocity not given")
        }
        return CircleBody(velocity: vector,
                          restitution: 0.9,
                          canMove: true,
                          affectedByGravity: true,
                          radius: radius,
                          position: coordinate,
                          canBeDestroyed: true)
    }
}
