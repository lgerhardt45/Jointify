//
//  ResultValues.swift
//  Jointify
//
//  Created by Annalena Feix on 20.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

import SwiftUI

struct ResultValues: View {
    // MARK: Stored Instance Properties
    let valueType: String
    let value: Int
    let showText: Bool
    
    var body: some View {
        VStack(spacing: 16.0) {
            if showText {
                Text(valueType)
                    .font(.system(size: 18))
                    .fontWeight(.light)
            }
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 80.0, height: 30.0)
                .foregroundColor(.lightGray)
                .overlay(
                    Text("\(value)°").padding(.horizontal))
        }
    }
}

struct ResultValues_Previews: PreviewProvider {
    static var previews: some View {
        ResultValues(valueType: "Max Value", value: 10, showText: true)
    }
}
