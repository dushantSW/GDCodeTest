//
// Created by dushantsw on 2017-05-13.
// Copyright (c) 2017 dushantsw. All rights reserved.
//

import Foundation


/// Defines all the errors that Location can throw
///
/// - longIsEmpty: if the longitude is NAN
/// - latIsEmpty: if the latitude is NAN
enum LocationError : Error {
    case longIsEmpty
    case latIsEmpty
}


/// Location, a dto defining the model of Location
public class Location {
    public private(set) var latitude: Double
    public private(set) var longitude: Double
    
    
    /// Creates a new instance privately
    ///
    /// - Parameters:
    ///   - lat: latitude
    ///   - long: longitude
    private init(lat: Double, long: Double) {
        self.latitude = lat
        self.longitude = long
    }
    
    
    /// Creates a new instance if validation passes
    ///
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longitude: longitude
    /// - Returns: Location
    /// - Throws: LocationError
    public static func ofLocation(latitude: Double, longitude: Double) throws -> Location {
        if latitude.isNaN {
            throw LocationError.latIsEmpty
        }
        
        if longitude.isNaN {
            throw LocationError.longIsEmpty
        }
        
        return Location.init(lat: latitude, long: longitude)
    }
}
