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
    
    // MARK: Environment Properties
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: Stored Instance Properties
    let headline: String
    let showLogo: Bool
    let allowToPopView: Bool
    let height: CGFloat
    
    // MARK: Body
    var body: some View {
        
        // Outer VStack
        VStack {
            
            if showLogo && allowToPopView {
                
                // put back button "on top" of logo
                ZStack {
                    Logo().padding()
                    HStack {
                        // Back button
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left").resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(height: Logo.height * CGFloat(0.5))
                        }.padding(.leading)
                        
                        // push button to the left
                        Spacer()
                    }
                }
                    
            } else if showLogo {
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
        LogoAndHeadlineView(headline: "My Headline", showLogo: false, allowToPopView: true, height: 200)
    }
}
