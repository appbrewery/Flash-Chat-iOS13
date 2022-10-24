//
//  Constants.swift
//  Flash Chat
//
//  Created by TechWithTyler on 9/9/22.
//  Copyright © 2022 TechWithTyler. All rights reserved.
//

struct Constants {

	static let appName = "⚡️FlashChat"

	static let threadCellIdentifier = "ThreadCell"

	static let bubbleCellIdentifier = "BubbleCell"

	static let cellNibName = "MessageCell"

	static let registerSegue = "RegisterToChat"

	static let loginSegue = "LoginToChat"

	static let threadSegue = "ShowThread"

	static let welcomeBackSegue = "WelcomeBackUser"

	struct BrandColors {

		static let purple = "BrandPurple"

		static let lightPurple = "BrandLightPurple"

		static let blue = "BrandBlue"

		static let lighBlue = "BrandLightBlue"

	}

	struct FStore {

		static let collectionName = "messages"

		static let threadsCollectionName = "threads"

		static let bubblesField = "bubbles"

		static let senderField = "sender"

		static let recipientsField = "recipients"

		static let bodyField = "body"

		static let dateField = "date"

	}
}

