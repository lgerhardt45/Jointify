//
//  InstructionsView.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - InstructionsView
struct InstructionsView: View {
    
    // MARK: Binding Instance Properties
    // navigation bar properties (hidden or not) lie onn avigation view
    //   (root view) and have to be modified there
    @Binding var isNavigationBarHidden: Bool
    
    // MARK: State Instance Properties
    @State var videoAsImageArray: [UIImage] = [] // sent to VideoPickerView
    @State var videoChosen: Bool = false         // sent to VideoPickerView
    @State private var showVideoPickerSheet: Bool = false

    // MARK: Body
    var body: some View {
        VStack {
            
            // Move video data to ProcessingView
            NavigationLink(
                destination: ProcessingView(
                    videoAsImageArray: self.$videoAsImageArray
                ),
                isActive: self.$videoChosen
            ) { EmptyView() }
            
            // pass the State variable to the other View which modifies it
            InstructionContent(
                showVideoPickerSheet: self.$showVideoPickerSheet
            )
                
                // open VideoPicker sheet
                .sheet(isPresented: self.$showVideoPickerSheet) {
                    // pass State vars on to ImagePickerView
                    VideoPickerView(
                        videoAsImageArray: self.$videoAsImageArray,
                        videoChosen: self.$videoChosen
                    )
            }
            
        }.navigationBarTitle(Text("Instructions"), displayMode: .inline)
            .navigationBarHidden(isNavigationBarHidden) // is turned to 'false' in WelcomeView
    }
}
