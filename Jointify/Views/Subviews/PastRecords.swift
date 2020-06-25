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
                        .frame(height: 60.0, alignment: .leading)
                        .foregroundColor(.lightGray)
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        .cornerRadius(5)
                        // use overlay() for simple ZStack
                        .overlay(
                            
                            // Alignment of image and text
                            HStack {
                                
                                // Image for last measurement - sorry for the force unwrap
                                Image(uiImage: self.getFirstImageFor(record: record))
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(5)
                                    .padding(.all, 4.0)
                                
                                // Text for previous measurement
                                VStack(alignment: .leading) {
                                    Text(
                                        """
                                        Record from \(record.date, formatter: DateFormats.dateOnlyFormatter)
                                        """
                                    ).allowsTightening(true)
                                        .scaledToFill()
                                    Text(
                                        """
                                        Max Value: \(String(Int(record.maxROM))), Min Value: \(String(Int(record.minROM)))
                                        """)
                                        .allowsTightening(true)
                                        .scaledToFill()
                                }
                                
                                // pushing image and text to left
                                Spacer()
                                
                            }.padding(.all, 4.0))
                }
            } else {
                Text("No previous records.")
                    .padding(.horizontal)
            }
        }
        .frame(height: 280.0)
        .padding(.trailing)
    }
    
    func getFirstImageFor(record: Measurement) -> UIImage {
        guard let firstEntry = record.frames.first,
            let firstImage = UIImage(data: firstEntry.image) else {
            return UIImage(named: "LogoMitText")!
        }
        return firstImage
    }
}

// MARK: - Previews
struct PastRecordsList_Previews: PreviewProvider {
    static var previews: some View {
        PastRecords()
    }
}
