//
//  PhysicsWorldDelegate.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 11/2/23.
//

protocol PhysicsWorldDelegate: AnyObject {
    func didDestroyedOutOfBoundBody()
    func didCollide()
    func didExplode()
    func didSpooky()
    func didBounce()
}
