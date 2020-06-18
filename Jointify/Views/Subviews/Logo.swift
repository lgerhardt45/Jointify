//
//  Logo.swift
//  Jointify
//
//  Created by Annalena Feix on 18.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

import SwiftUI

struct Logo: View {
    var body: some View {
          Image("LogoMitText")    .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 192, height: 64)
    }
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
