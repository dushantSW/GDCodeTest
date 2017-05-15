//
//  SearchRequest.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-15.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation


/// SearchRequestError defines all the errors thrownn by SearchRequest
///
/// - ageToLittle: if the age is beyond last min age (16)
/// - ageToBig: if the age surpasses last max age (70)
enum SearchRequestError : Error {
    case ageToLittle
    case ageToBig
}

/// SearchRequest, a dto defining model of searching
public class SearchRequest {
    private let lastMinAge = 16
    private let lastMaxAge = 70
    
    public private(set) var currentRow = 0
    public let pageSize = 50
    
    public private(set) var minAge: Int?
    public private(set) var maxAge: Int?
    public var location: Location?
    
    
    /// Creates a new instance
    init() {
        minAge = 18
        maxAge = 70
    }
    
    
    /// Sets the min age
    ///
    /// - Parameter age: age
    /// - Throws: SearchRequestError
    func setMinAge(age: Int) throws {
        if age <= lastMinAge {
            throw SearchRequestError.ageToLittle
        }
        
        minAge = age
        
        if minAge! > maxAge! {
            maxAge = minAge
        }
    }
   
    
    /// Sets the max age
    ///
    /// - Parameter age: age
    /// - Throws: SearchRequestError
    func setMaxAge(age: Int) throws {
        if age >= lastMaxAge {
            throw SearchRequestError.ageToBig
        }
        
        maxAge = age
        
        if maxAge! < minAge! {
            minAge = maxAge
        }
    }
    
    
    /// Increments +1 to current row
    func incrementToNextPage() {
        currentRow += 1
    }
    
    
    /// Decrement -1 to current row
    func decrementToPreviousPage() {
        currentRow -= 1
    }
}
