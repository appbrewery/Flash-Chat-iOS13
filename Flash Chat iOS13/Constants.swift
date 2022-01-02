//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Vaishu Adi on 1/2/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

struct K {
    static let appName = "🌻SunChatz"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let teal = "BrandTeal"
        static let lightBlue = "BrandLightBlue"
        static let yellow = "BrandYellow"
        static let lightYellow = "BrandLightYellow"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

