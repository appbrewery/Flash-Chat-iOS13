//
//  Constants.swift
//  Flash Chat
//
//  Created by TechWithTyler on 9/9/22.
//  Copyright © 2022 TechWithTyler. All rights reserved.
//

struct Constants {

	static let appName = "⚡️FlashChat"

	static let cellIdentifier = "ReusableCell"

	static let cellNibName = "MessageCell"

	static let registerSegue = "RegisterToChat"

	static let loginSegue = "LoginToChat"

	static let welcomeBackSegue = "WelcomeBackUser"

	struct BrandColors {

		static let purple = "BrandPurple"

		static let lightPurple = "BrandLightPurple"

		static let blue = "BrandBlue"

		static let lighBlue = "BrandLightBlue"

	}

	struct FStore {

		static let collectionName = "messages"

		static let senderField = "sender"

		static let bodyField = "body"

		static let dateField = "date"

	}
}

