//
// Created by dushantsw on 2017-05-13.
// Copyright (c) 2017 dushantsw. All rights reserved.
//

import Foundation


/// Profile, a dto defining a model of profile.
class Profile {
    struct JSONFieldKey {
        static let id = "ProfileId"
        static let name = "ProfileName"
        static let age = "Age"
        static let type = "ProfileType"
        static let avatarId = "MainMediaId"
        static let travelling = "IsTravelling"
        static let online = "IsOnline"
        static let distance = "Distance"
    }
    
    var id: Int!
    var name: String!
    var age: Int!
    var type: Int!
    var avatarId: String!

    var travelling: Bool!
    var online: Bool!
    var isFavourite: Bool!
    var distance: String!
    
    
    /// Creates a new instance with json data
    ///
    /// - Parameter json: NSDictinary containing json profile.
    public init(json: NSDictionary?) {
        self.id = json?.value(forKey: JSONFieldKey.id) as? Int
        self.name = json?.value(forKey: JSONFieldKey.name) as? String
        self.age = json?.value(forKey: JSONFieldKey.age) as? Int
        self.type = json?.value(forKey: JSONFieldKey.type) as? Int
        self.avatarId = json?.value(forKey: JSONFieldKey.avatarId) as? String
        self.travelling = json?.value(forKey: JSONFieldKey.travelling) as? Bool
        self.online = json?.value(forKey: JSONFieldKey.online) as? Bool
        self.distance = json?.value(forKey: JSONFieldKey.distance) as? String
    }

    
    /// Checks if user is online
    ///
    /// - Returns: true if online
    public func isOnline() -> Bool {
        return self.online != nil ? self.online! : false
    }

    
    /// Checks if user is travelling
    ///
    /// - Returns: true if travelling
    public func isTravelling() -> Bool {
        return self.travelling != nil ? self.travelling! : false
    }
}
