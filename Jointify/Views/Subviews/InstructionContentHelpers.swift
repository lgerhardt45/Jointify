//
//  InstructionPoint.swift
//  Jointify
//
//  Created by user175619 on 7/3/20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - InstructionPoint
struct InstructionPoint: View {
    
    // MARK: Stored Instance Properties
    let text: String
    let image: Image
    let width: CGFloat
    
    // MARK: Body
    var body: some View {
        // headline
        VStack(spacing: 8) {
            Text(self.text)
                .font(.body)
                .multilineTextAlignment(.center)
            
            self.image
                .resizable()
                .scaledToFit()
                .cornerRadius(5)
            
        }
        .frame(width: width)
    
    }
}

// MARK: - InstructionHeadline
struct InstructionHeadline: View {
    
    // MARK: Stored Instance Properties
    let headline: String
    
    // MARK: Body
    var body: some View {
        // headline
        Text(self.headline)
            .font(.headline)
    }
}

// MARK: - BulletedList
struct BulletedList: View {
    
    // MARK: Stored Instance Properties
    private let headline: String
    private let text: [String]
    
    // MARK: Initializers
    init(headline: String, text: [String]) {
        self.headline = headline
        self.text = text
    }
    
    // MARK: Body
    var body: some View {
        
        VStack(spacing: 8) {
            
            // headline
            Text(self.headline)
                .font(.headline)
            
            VStack(alignment: .leading) {
                
                // bulletpoints
                ForEach(self.text, id: \.self) { bulletpoint in
                    
                    HStack(alignment: .top) {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                            .padding(.top, 7.5)
                        
                        Text(bulletpoint)
                            .font(.body)
                    }
                }
            }
        }
    }
}
