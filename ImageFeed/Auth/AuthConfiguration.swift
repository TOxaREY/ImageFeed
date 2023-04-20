//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 21.02.2023.
//

import Foundation

let accessKey = "1ztHDyJZc7Xupho4KXZSLjVSaPEsOV9_Okrea192cMc"
let secretKey = "qEE1xHz9dz319vyXl-ts2lul1h3lwj1A2E7Mx-90UH0"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"

let defaultBaseURL = URL(string: "https://api.unsplash.com")!
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

let showWebViewSegueIdentifier = "ShowWebView"
let showAuthenticationScreenSegueIdentifier = "ShowAuthView"

struct AuthConfiguration {
    let accessKeyAuthConfig: String
    let secretKeyAuthConfig: String
    let redirectURIAuthConfig: String
    let accessScopeAuthConfig: String
    let defaultBaseURLAuthConfig: URL
    let authURLStringAuthConfig: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKeyAuthConfig: accessKey,
                                 secretKeyAuthConfig: secretKey,
                                 redirectURIAuthConfig: redirectURI,
                                 accessScopeAuthConfig: accessScope,
                                 defaultBaseURLAuthConfig: defaultBaseURL,
                                 authURLStringAuthConfig: unsplashAuthorizeURLString)
    }
}
