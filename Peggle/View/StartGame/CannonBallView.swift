//
//  CannonBallView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import SwiftUI

struct CannonBallView: View {
    var radius: Double
    var body: some View {
        Image("ball")
            .resizable()
            .frame(width: radius * 2, height: radius * 2)
    }
}

struct CannonBallView_Previews: PreviewProvider {
    static var previews: some View {
        CannonBallView(radius: 20.0)
    }
}
