//
//  AppDelegate.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		configureKeyboard()
		FirebaseApp.configure()
		return true
	}
	
	func configureKeyboard() {
		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.enableAutoToolbar = false
		IQKeyboardManager.shared.shouldResignOnTouchOutside = true
	}
	
	// MARK: UISceneSession Lifecycle
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	static func checkRecipientRegistrationStatus(_ recipients: [String], inDatabase database: Firestore, completionHandler: @escaping ((_ allRecipientsRegistered: Bool, _ error: Error?) -> Void)) async {
		let unregisteredRecipients = await fetchUsers(inDatabase: database, recipients: recipients, completionHandler: completionHandler)
		if unregisteredRecipients.isEmpty {
			completionHandler(true, nil)
		} else {
			completionHandler(false, nil)
		}
	}

	static func fetchUsers(inDatabase database: Firestore, recipients: [String], completionHandler: @escaping ((_ allRecipientsRegistered: Bool, _ error: Error?) -> Void)) async -> [String] {
		var unregisteredRecipients: [String] = []
		for recipient in recipients.filter({ recipient in
			return recipient != Auth.auth().currentUser?.email
		}) {
			// Asynchronously fetch this user from Firebase, and append to unregisteredRecipients if they don't exist.
			do {
				let userQuerySnapshot = try await database.collection(Constants.FStore.usersCollectionName)
					.whereField(Constants.FStore.emailField, isEqualTo: recipient)
					.getDocuments()
				if userQuerySnapshot.documents.isEmpty {
					unregisteredRecipients.append(recipient)
				}
			} catch {
				completionHandler(false, error)
				return unregisteredRecipients
			}
		}
		return unregisteredRecipients
	}
	
	static func showError(_ error: Error, customMessage message: String? = nil, inViewController viewController: UIViewController) {
		let alert = UIAlertController(title: message ?? error.localizedDescription, message: nil, preferredStyle: .alert)
		let dismissAction = UIAlertAction(title: "OK", style: .default)
		alert.addAction(dismissAction)
		let haptics = UINotificationFeedbackGenerator()
		haptics.notificationOccurred(.error)
		viewController.present(alert, animated: true)
	}
	
	
}

