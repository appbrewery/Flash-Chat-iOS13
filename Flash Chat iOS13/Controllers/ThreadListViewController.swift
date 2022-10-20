//
//  ThreadListViewController.swift
//  Flash Chat
//
//  Created by TechWithTyler on 10/13/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ThreadListViewController: UITableViewController {

	var threads: [Thread] = []

	let database = Firestore.firestore()

	override func viewDidLoad() {
		super.viewDidLoad()
		loadThreads()
	}

	func loadThreads() {
		database.collection(Constants.FStore.threadsCollectionName)
			.whereField(Constants.FStore.recipientsField, arrayContains: (Auth.auth().currentUser?.email)!)
			.order(by: Constants.FStore.dateField, descending: false)
			.addSnapshotListener { [self] (querySnapshot, error) in
				threads = []
				guard Auth.auth().currentUser != nil else { return }
				if let error = error {
					AppDelegate.showError(error, inViewController: self)
				} else {
					if let snapshotDocuments = querySnapshot?.documents {
						for doc in snapshotDocuments {
							let data = doc.data()
							if let recipients = data[Constants.FStore.recipientsField] as? [String],
							   let bubbles = data[Constants.FStore.bubblesField] as? [Message], let idString = data[Constants.FStore.idField] as? String {
								let newThread = Thread(idString: idString, recipients: recipients, messageBubbles: bubbles)
								threads.append(newThread)
								DispatchQueue.main.async { [self] in
									let indexPath = IndexPath(row: threads.count - 1, section: 0)
									tableView?.reloadData()
									tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
								}
							}
						}
					}
				}
			}
	}

	@IBAction func addThread(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "New Message", message: "Enter recipient email address", preferredStyle: .alert)
		var textField = UITextField()
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		let addAction = UIAlertAction(title: "Add", style: .default) { [self] (action) in
			if let messageSender = Auth.auth().currentUser?.email {
				let recipient = textField.text ?? messageSender
				let data: [String : Any] = [
					Constants.FStore.senderField : messageSender,
					Constants.FStore.bubblesField : [Message](),
					Constants.FStore.recipientsField : [messageSender, recipient],
					Constants.FStore.idField : UUID().uuidString,
					Constants.FStore.dateField : Date()
				]
				database.collection(Constants.FStore.threadsCollectionName).addDocument(data: data) { [self] error in
					if let error = error {
						AppDelegate.showError(error, inViewController: self)
					} else {
						DispatchQueue.main.async { [self] in
							goToThread()
						}
					}
				}
			}
		}
		alert.addAction(addAction)
		alert.addAction(cancelAction)
		alert.addTextField { alertTextField in
			textField = alertTextField
		}
		present(alert, animated: true)
	}

	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return threads.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.threadCellIdentifier, for: indexPath)
		let row = indexPath.row
		var contentConfiguration = UIListContentConfiguration.cell()
		var recipientsExcludingSender = threads[row].recipients
		recipientsExcludingSender.removeAll { recipient in
			return recipient == Auth.auth().currentUser?.email
		}
		let recipients = recipientsExcludingSender.joined()
		contentConfiguration.text = recipients
		cell.contentConfiguration = contentConfiguration
		cell.accessoryType = .disclosureIndicator
		return cell
	}


	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			database.collection(Constants.FStore.threadsCollectionName).getDocuments() { (querySnapshot, error) in
				if let error = error {
					AppDelegate.showError(error, inViewController: self)
				} else {
					if let threads = querySnapshot?.documents {
						for thread in threads {
							if thread == threads[indexPath.row] {
								self.database.collection(Constants.FStore.threadsCollectionName).document(thread.documentID).delete { [self]
									error in
									if let error = error {
										AppDelegate.showError(error, inViewController: self)
									} else {
										tableView.reloadData()
									}
								}
							}
						}
					}
				}
			}
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		goToThread()
	}

	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		if let chatVC = segue.destination as? ChatViewController {
			// Pass the selected object to the new view controller.
			if let selectedRow = tableView.indexPathForSelectedRow?.row {
				chatVC.selectedThread = threads[selectedRow]
			} else {
				chatVC.selectedThread = threads.last!
			}
		}
	}

	func goToThread() {
		performSegue(withIdentifier: Constants.threadSegue, sender: self)
	}

}
