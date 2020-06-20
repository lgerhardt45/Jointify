//
//  LogoAndHeadlineView.swift
//  Jointify
//
//  Created by Annalena Feix on 20.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - LogoAndHeadlineView
struct LogoAndHeadlineView: View {
    
    // MARK: Stored Instance Properties
    let headline: String
    let showLogo: Bool
    let height: CGFloat
    
    // MARK: Body
    var body: some View {
        VStack {
            if showLogo {
                Logo().padding()
            }
            Spacer()
            Text(headline)
                .font(.largeTitle)
                .font(.system(size:48))
        }.frame(height: height)
    }
}

// MARK: - Previews
struct LogoAndHeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        LogoAndHeadlineView(headline: "test", showLogo: true, height: 200)
    }
}
