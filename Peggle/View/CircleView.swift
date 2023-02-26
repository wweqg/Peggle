//
//  CircleView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 23/1/23.
//

import SwiftUI

struct CircleView: View {
    @State var x: Double
    @State var y: Double
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .position(x: x, y: y)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        x = value.location.x
                        y = value.location.y
                    }
            )
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView(x: 0, y: 0)
    }
}
