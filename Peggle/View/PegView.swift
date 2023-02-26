//
//  PegView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 23/1/23.
//

import SwiftUI

struct PegView: View {
    @Binding var pos: CGPoint
    @Binding var willBeDestroyed: Bool
    @State var currentImage = "greenPeg-glow"
    var pegType: PegType
    var pegRadius: Double
    let explosion = ["explosion-1", "explosion-2", "explosion-3", "explosion-4", "explosion-5", "explosion-6",
                     "explosion-7", "explosion-8", "explosion-9", "explosion-10", "explosion-11", "explosion-12",
                     "explosion-13", "explosion-14", "explosion-15", "explosion-16", "explosion-17",
                     "explosion-19", "explosion-20", "greenPeg-glow"]
    var body: some View {
        if pegType == PegType.spookyPeg {
            if willBeDestroyed {
                Image("greenPeg-glow")
                    .resizable()
                    .frame(width: pegRadius * 2, height: pegRadius * 2)
                    .position(pos)
            } else {
                Image("greenPeg")
                    .resizable()
                    .frame(width: pegRadius * 2, height: pegRadius * 2)
                    .position(pos)
            }
        } else if pegType == PegType.KaBoomPeg {
            if willBeDestroyed {
                Image(currentImage)
                    .resizable()
                    .frame(width: pegRadius * 2, height: pegRadius * 2)
                    .position(pos)
                    .onAppear {
                        let animatedImages = explosion.dropFirst()
                        for image in animatedImages {
                            DispatchQueue.main.asyncAfter(deadline: .now() +
                                                          Double(animatedImages.firstIndex(of: image)!) * 0.1) {
                                withAnimation(.linear(duration: 0.1)) {
                                    self.currentImage = image
                                }
                            }
                        }
                    }
            } else {
                Image("greenPeg")
                    .resizable()
                    .frame(width: pegRadius * 2, height: pegRadius * 2)
                    .position(pos)
                    .shadow(color: Color.red, radius: pegRadius)
            }
        } else {
            if willBeDestroyed {
                Image(pegType.rawValue + "-glow")
                    .resizable()
                    .frame(width: pegRadius * 2, height: pegRadius * 2)
                    .position(pos)
            } else {
                Image(pegType.rawValue)
                    .resizable()
                    .frame(width: pegRadius * 2, height: pegRadius * 2)
                    .position(pos)
            }
        }
    }
}

struct PegView_Previews: PreviewProvider {
    static var previews: some View {
        PegView(pos: .constant(CGPoint(x: 50, y: 50)), willBeDestroyed: .constant(false),
                pegType: PegType.bluePeg, pegRadius: 30.0)
    }
}
