//
//  GameDisplayDelegate.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 11/2/23.
//

protocol GameDisplayDelegate: AnyObject {
    func didMove(peggleObj: PeggleObject, to: Point)
    func removeDestroyedPeggleObject()
}
