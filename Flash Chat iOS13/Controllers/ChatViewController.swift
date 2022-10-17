//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView?

    @IBOutlet weak var messageTextfield: UITextField?

	let database = Firestore.firestore()

	var messages: [Message] = []

	var selectedThread: Thread? = nil

	let messagesForSelectedThread = Constants.FStore.collectionName
    
	override func viewDidLoad() {
		super.viewDidLoad()
		title = Constants.appName
		tableView?.delegate = self
		tableView?.dataSource = self
		messageTextfield?.delegate = self
		tableView?.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.bubbleCellIdentifier)
		if let thread = selectedThread {
			loadMessages(for: thread)
		}
	}

	func loadMessages(for thread: Thread) {
		database.collection(Constants.FStore.threadsCollectionName).document(selectedThread?.idString ?? UUID().uuidString).collection(Constants.FStore.bubblesField)
			.order(by: Constants.FStore.dateField, descending: false)
			.addSnapshotListener { [self] (querySnapshot, error) in
			messages = []
			guard Auth.auth().currentUser != nil else { return }
			if let error = error {
				AppDelegate.showError(error, inViewController: self)
			} else {
				if let snapshotDocuments = querySnapshot?.documents {
					for doc in snapshotDocuments {
						let data = doc.data()
						if let sender = data[Constants.FStore.senderField] as? String,
						   let body = data[Constants.FStore.bodyField] as? String {
							let newMessage = Message(sender: sender, body: body)
							messages.append(newMessage)
							DispatchQueue.main.async { [self] in
								let indexPath = IndexPath(row: messages.count - 1, section: 0)
								tableView?.reloadData()
								tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
							}
						}
					}
				}
			}
		}
	}
    
    @IBAction func sendPressed(_ sender: Any) {
		if let messageBody = messageTextfield?.text,
		   let messageSender = Auth.auth().currentUser?.email {
			let currentDate = Date()
			let data: [String : Any] = [
				Constants.FStore.senderField : messageSender,
				Constants.FStore.bodyField : messageBody,
				Constants.FStore.dateField : currentDate.timeIntervalSince1970
			]
			database.collection(Constants.FStore.threadsCollectionName).document(selectedThread?.idString ?? UUID().uuidString).collection(Constants.FStore.bubblesField).addDocument(data: data) { [self] error in
				if let error = error {
					AppDelegate.showError(error, inViewController: self)
				} else {
					DispatchQueue.main.async { [self] in
						messageTextfield?.text?.removeAll()
					}
				}
			}
		}
    }
    
	@IBAction func logOutPressed(_ sender: UIBarButtonItem) {
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
			navigationController?.popToRootViewController(animated: true)
		} catch let signOutError as NSError {
			AppDelegate.showError(signOutError, inViewController: self)
		}
		
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		sendPressed(textField)
		return true
	}

}

extension ChatViewController {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = messages[indexPath.row]
		let currentUser = Auth.auth().currentUser?.email
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bubbleCellIdentifier, for: indexPath) as? MessageCell
		cell?.label?.text = message.body
		if message.sender == currentUser {
			cell?.leftImageView?.isHidden = true
			cell?.rightImageView?.isHidden = false
			cell?.messageBubble?.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
			cell?.label?.textColor = UIColor(named: Constants.BrandColors.purple)
		} else {
			cell?.leftImageView?.isHidden = false
			cell?.rightImageView?.isHidden = true
			cell?.messageBubble?.backgroundColor = UIColor(named: Constants.BrandColors.purple)
			cell?.label?.textColor = UIColor(named: Constants.BrandColors.lightPurple)

		}
		return cell!
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
	}

}
