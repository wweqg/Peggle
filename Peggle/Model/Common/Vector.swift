//
//  Vector.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import Foundation

struct Vector {
    var x: Double
    var y: Double

    init(x: Double = 0.0, y: Double = 0.0) {
        self.x = x
        self.y = y
    }

    func magnitude() -> Double {
        sqrt(x * x + y * y)
    }
    func add(to vector: Vector) -> Vector {
        Vector(x: self.x + vector.x, y: self.y + vector.y)
    }
    func addTo(point: Point) -> Point {
        Point(xCoordinate: point.xCoordinate + x, yCoordinate: point.yCoordinate + y)
    }

    func subtract(_ vector: Vector) -> Vector {
        Vector(x: self.x - vector.x, y: self.y - vector.y)
    }

    func scalarMultiply(with scalar: Double) -> Vector {
        Vector(x: self.x * scalar, y: self.y * scalar)
    }

    func normalized() -> Vector {
        let mag = magnitude()
        return Vector(x: x / mag, y: y / mag)
    }

    func dotProduct(with other: Vector) -> Double {
        x * other.x + y * other.y
    }

    func angle(with other: Vector) -> Double {
        let dot = dotProduct(with: other)
        let magProduct = magnitude() * other.magnitude()
        return acos(dot / magProduct)
    }
}
