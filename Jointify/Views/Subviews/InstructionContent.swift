//
//  InstructionContent.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - InstructionContent
struct InstructionContent: View {
    
    // MARK: Body
    var body: some View {
        VStack {
            Text("why the fuck would we add fifty lines of instructions?")
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

struct InstructionContent_Previews: PreviewProvider {
    static var previews: some View {
        InstructionContent()
    }
}
