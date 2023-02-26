//
//  CannonView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import SwiftUI

struct CannonView: View {
    @Binding var shoot: Bool
    var size: Double
    var body: some View {
        if shoot {
            Image("cannon-shooting")
                .resizable()
                .frame(width: size, height: size)
        } else {
            Image("cannon-default")
                .resizable()
                .frame(width: size, height: size)
        }
    }
}

struct CannonView_Previews: PreviewProvider {
    static var previews: some View {
        CannonView(shoot: .constant(false),
                   size: 80.0)
    }
}
