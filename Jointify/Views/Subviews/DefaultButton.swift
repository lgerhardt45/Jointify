//
//  DefaultButton.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - DefaultButton
struct DefaultButton<ConformsToView: View>: View {
    
    // MARK: Stored Instance Properties
    private let action: () -> Void
    private let label: ConformsToView
    
    // MARK: Initializers
    init(action: @escaping () -> Void, @ViewBuilder label: () -> ConformsToView) {
        self.action = action
        self.label = label()
    }
    
    // MARK: Body
    var body: some View {
        Button(action: action, label: {
            self.label
                .padding()
                .background(Color.lightBlue)
                .foregroundColor(.white)
                .cornerRadius(40)
                .font(.system(size: 18, weight: .bold))
                .allowsTightening(true)
                .lineLimit(1)
        
        })
        
    }
}

// MARK: - Previews
struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(action: {}, label: {
            Text("Default Button")
        })
    }
    
}

extension Color {
    static let lightBlue = Color("ButtonColor")
}


