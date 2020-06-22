//
//  Logo.swift
//  Jointify
//
//  Created by Annalena Feix on 18.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - Logo
struct Logo: View {
    
    // MARK: Type Properties
    static let width: CGFloat = 192
    static let height: CGFloat = 64
    
    // MARK: Body
    var body: some View {
        Image("LogoMitText")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: Logo.width, height: Logo.height)
    }
}

// MARK: - Previews
struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
