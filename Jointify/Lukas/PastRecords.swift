//
//  PastRecordsList.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - PastRecordsList
struct PastRecords: View {
    
    // MARK: Stored Instance Properties
    let records: [Record] = []
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .leading) {
            Text("Deine vorherigen Messungen:")
                .font(.headline)        .padding(.horizontal)
            
            // change to records when mock data added
            List(1..<6) { row in
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 50.0, alignment: .leading)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    // use overlay() for simple ZStack
                    .overlay(
                        Text("Record \(row)").padding(.horizontal),
                        alignment: .leading
                        )
                
            }
        }
    }
}

struct PastRecordsList_Previews: PreviewProvider {
    static var previews: some View {
        PastRecords()
    }
}
