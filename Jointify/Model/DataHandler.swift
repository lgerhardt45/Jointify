//
//  DataHandler.swift
//  Jointify
//
//  Created by Lukas Gerhardt on 22.06.20.
//  Copyright © 2020 Lukas Gerhardt. All rights reserved.
//

// MARK: - Imports
import Foundation

// MARK: - DataHandler
enum DataHandler {
    
    // MARK: Stored Type Properties
    static var measurementStorageFileName = "measurements.json"
    
    static var mockMeasurements: [Measurement] = [
        Measurement(),
        Measurement(),
        Measurement()
    ]

    // MARK: Computed Type Properties
    static var actualMeasurements: [Measurement] {
        
        // get them from internal storage
        print("Trying to get stored Measurement instances")
        if let storedMeasurements =
            DataHandler.loadFromJSON(
                from: DataHandler.measurementStorageFileName,
                expecting: [Measurement].self
            ) {
            print("Successfully retrieved \(storedMeasurements.count) Measurements")
            return storedMeasurements
        } else {
            print("Couldn't retrieve Measurements")
            return []
        }
    }
    
    // MARK: Type Methods
    /// Stores an object in JSON format for a given file name (e.g. "LoginToken.json")
    static func saveToJSON<TObjectType: Encodable>(this object: TObjectType?, as fileName: String) {

        guard let object = object else {
            print("Object is nil, cannot save to JSON.")
            return
        }
        
        print("Attempting to save object \(object) in JSON as \(fileName).")
        
        do {
            let data = try JSONEncoder().encode(object)
            let jsonFileWrapper = FileWrapper(regularFileWithContents: data)
            
            let location = getDeviceDocumentDirectoryUrl(for: fileName)

            try jsonFileWrapper.write(
                to: location,
                options: .atomic,
                originalContentsURL: nil
            )
            print("\(object) saved to JSON.")
        } catch {
            print("Error saving \(object) to JSON: \(error).")
        }
    }
    
    /// Loads an object from a given file name (e.g. "LoginToken.json") and decodes it to the expected type
    ///
    /// - Parameters:
    ///   - fileName: file name that is to be loaded
    ///   - type: type of object that file (if found) is to be decoded to
    /// - Returns: the object, if file was found and decoding worked, nil otherwise
    static func loadFromJSON<TObjectType: Decodable>(
        from fileName: String, expecting type: TObjectType.Type
    ) -> TObjectType? {
        
        print("Attempting to load object of type \(type) from \(fileName).")
        do {

            let location = getDeviceDocumentDirectoryUrl(for: fileName)
            
            let fileWrapper = try FileWrapper(
                url: location,
                options: .immediate
            )
            guard let data = fileWrapper.regularFileContents else {
                throw NSError()
            }
            let returnValue: TObjectType = try JSONDecoder().decode(type, from: data)
            print("Succesfully loaded object \(returnValue) from \(fileName).")
            return returnValue

        } catch {
            print("Error loading object of type \(type) from JSON: \(error).")
            return nil
        }
    }
    
    static func deleteFileFromDocumentDirectory(fileName: String) {
        print("Attempting to delete file \(fileName).")
        do {
            let fileManager = FileManager.default
            let location = getDeviceDocumentDirectoryUrl(for: fileName)
            try fileManager.removeItem(at: location)
        } catch {
            print("Error deleting file \(fileName): \(error).")
            return
        }
        print("Successfully deleted file \(fileName).")
    }
    
    static func saveNewMeasurement(measurement: Measurement) {
        var measurements = DataHandler.actualMeasurements
        measurements.append(measurement)
        DataHandler.saveToJSON(this: measurements, as: DataHandler.measurementStorageFileName)
    }
    
    // MARK: Private Type Methods
    /// Returns the URL for the device storage directory appended with a given fileName
    private static func getDeviceDocumentDirectoryUrl(for fileName: String) -> URL {
        guard let documentsDirectory = FileManager()
            .urls(for: .documentDirectory,
                  in: .userDomainMask).first else {
                    fatalError("Can't access the document directory in the user's home directory.")
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
}
