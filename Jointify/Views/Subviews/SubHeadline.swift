//
//  SubHeadline.swift
//  Jointify
//
//  Created by Annalena Feix on 20.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

import SwiftUI

struct SubHeadline: View {
    // MARK: Stored Instance Properties
    let subheadline: String
    let width: CGFloat
    
    var body: some View {
        Text(subheadline)
            .font(.subheadline)
            .fontWeight(.light)
            .multilineTextAlignment(.center)
            .font(.system(size:20))
            .frame(width: width)
    }
}

struct SubHeadline_Previews: PreviewProvider {
    static var previews: some View {
        SubHeadline(subheadline: "lorem ipsum", width: 220.0)
    }
}
