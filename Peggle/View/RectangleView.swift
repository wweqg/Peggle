//
//  RectangleView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 25/2/23.
//

import SwiftUI

struct RectangleView: View {
    @Binding var height: Double
    @Binding var width: Double
    @Binding var pos: CGPoint
    var body: some View {
        Image("rectangle")
            .resizable()
            .frame(width: width, height: height + (height * (1 / 2)))
            .position(pos)
    }
}

struct RectangleView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleView(height: .constant(50.0), width: .constant(50.0), pos: .constant(CGPoint.zero))
    }
}
