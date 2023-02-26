//
//  BucketView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import SwiftUI

struct BucketView: View {
    var size: Double
    var body: some View {
        Image("bucket")
            .resizable()
            .frame(width: size, height: size)
    }
}

struct BucketView_Previews: PreviewProvider {
    static var previews: some View {
        BucketView(size: 100.0)
    }
}
