//
//  Point.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 21/1/23.
//

struct Point: Codable {
    static let ZERO = Point(xCoordinate: 0, yCoordinate: 0)
    private(set) var xCoordinate: Double
    private(set) var yCoordinate: Double
}
