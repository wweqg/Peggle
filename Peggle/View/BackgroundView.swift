//
//  BackgroundView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 20/1/23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        VStack {
            Image("background")
                .resizable()
                .clipped()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
