//
//  PastRecordsList.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 11.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: Imports
import SwiftUI

// MARK: - PastRecords
struct PastRecords: View {
    
    // MARK: Stored Instance Properties
    var records: [Measurement] {
        DataHandler.actualMeasurements
    }
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Records:")
                .font(.system(size: 18))
                .fontWeight(.light)
            .padding(.horizontal)
            
            if !records.isEmpty {

                List(records) { record in
                    
                    RoundedRectangle(cornerRadius: 5)
                        .padding(.vertical, 4.0)
                        .frame(height: 50.0, alignment: .leading)
                        .foregroundColor(.lightGray)
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        .cornerRadius(5)
                        // use overlay() for simple ZStack
                        .overlay(
                            Text("Record from \(record.date)").padding(.horizontal),
                            alignment: .leading
                    )
                }
                
            } else {
                Text("No previous records.")
            }
        }
        .frame(height: 280.0)
    }
}

// MARK: - Previews
struct PastRecordsList_Previews: PreviewProvider {
    static var previews: some View {
        PastRecords()
    }
}
