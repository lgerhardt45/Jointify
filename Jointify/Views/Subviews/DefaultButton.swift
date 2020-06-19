//
//  DefaultButton.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: Button Mode
enum ButtonMode {
    case enabled, disabled, success
}

// MARK: - DefaultButton
struct DefaultButton<ConformsToView: View>: View {
    
    // MARK: Stored Instance Properties
    private let mode: ButtonMode // modify button style from the outside in a consistent style
    private let action: () -> Void
    private let label: ConformsToView
    
    // MARK: Computed Instance Properties
    var backgroundColorByMode: Color {
        switch mode {
        case .enabled: return Color.lightBlue
        case .disabled: return Color.gray
        case .success: return Color.green
        }
    }
    
    var enabled: Bool {
        switch mode {
        case .enabled: return true
        default: return false
        }
    }
    
    // MARK: Initializers
    init(mode: ButtonMode = .enabled, action: @escaping () -> Void, @ViewBuilder label: () -> ConformsToView) {
        self.mode = mode
        self.action = action
        self.label = label()
    }
    
    // MARK: Body
    var body: some View {
        Button(action: action, label: {
            self.label
                .padding()
                .background(backgroundColorByMode)
                .foregroundColor(.white)
                .cornerRadius(40)
                .font(.system(size: 18, weight: .bold))
                .allowsTightening(true)
                .lineLimit(1)
                .shadow(radius: enabled ? 5 : 0, y: enabled ? 4 : 0)
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

// MARK: Extension Color
/// add the default colour for the button
extension Color {
    static let lightBlue = Color("ButtonColor")
}
