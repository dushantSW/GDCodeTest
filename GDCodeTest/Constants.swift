//
//  Constants.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-13.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation

/**
 * Constants contains all the static variables that are used by the
 * system.
 *
 * @author dushantsw
 */
class Constants {
    
    /**
     * URL to the authentication endpoint
     */
    static let OAUTH_URL = "https://account-live.cpcconnect.net/auth/token";
    
    /**
     * URL to the profile endpoint
     */
    static let PROFILE_URL = "https://profile-live.cpcconnect.net/search/closest";
    
    /**
     * URL to the media endpoint
     */
    static let MEDIA_URL = "https://media-live.cpcconnect.net/media/";
    
    /**
     * Creates an absolute url from media id
     * 
     * @param mediaId String mediaId
     * @returns Absolute URL to the media.
     */
    public static func mediaAbsURLWithMediaId(mediaId: String) -> String {
        return MEDIA_URL.appending(mediaId).appending("/cropped?size=350&croppingScheme=0")
    }
}
