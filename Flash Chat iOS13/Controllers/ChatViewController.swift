//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    //добавили референс для базы данных
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        //создаем делегат, dataSourse работает как делегат из коробки
        //  сделаем заголовок на navigateBar
        title = K.appName
        //  спрячем кнопку back на navigateBar, чтобы не путать с logOut
        navigationItem.hidesBackButton = true
        
        //nib = UINib. nibName = имя файла XIB. Но мы сохранили его в константах K, nibName: K.cellNibName, а forCellReuseIdentifier:  K.cellIdentifier
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
    
    func loadMessages () {
       
        //доступ к коллекции с определнным названием в базе данных
        db.collection(K.FStore.collectionName)
            .order(by:K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error ) in
            
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }
            else {
                self.messages = []
                if let snapshotDocument =  querySnapshot?.documents {
                    //переберем  в цикле элементы массива
                    for doc in snapshotDocument {
                       // print(doc.data()) - проверили работу
                        let data = doc.data()
                        //разделим данные на sender и body
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                //section: 0 означает одну первую секцию
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                           
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //присваиваем messageBody текст, введенный пользователем в UITextField
        //также нужно присвоить имя отправителя.  Как это сделать, есть в разделе аутентификации - Manage Users in Firebase
        if let messageBody  = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender,
                                                                      K.FStore.bodyField: messageBody,
                                                                      K.FStore.dateField: Date().timeIntervalSince1970
                                                                     ]) { (error) in
                if let e = error {
                     print("There was an issue saving data to firestore, \(e)")
                } else {
                    print ("Successfully saved data")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
            //метод возвращающий к корневому контроллеру
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
          
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //возвращает повторно используемцю ячейку table view для специального повторно используемого идентификатора и добавляет  ее в table
    // identifier можно найти в стриборд в информации о прототипе ячейки (в этом случае мы сохранили констакты в отдельной структуре K, поэтому это значение K.cellIdentifier
    let message = messages[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier
                                             , for: indexPath)
    as! MessageCell
    cell.label.text = message.body
    //присваиваем тексту ячейки значение, а затем возвращаем ее
    //index.row - номер ячейки, нумеруется сверху сниз с 0, преобразуем ее в индекс элемента из массива masseges и выбираем body (содержимое ячейки)
    
    //а теперь кастомизируем ячейку
    //это сообщение от текущего пользователя
    if message.sender == Auth.auth().currentUser?.email {
        cell.leftImageView.isHidden = true
        cell.rightImageView.isHighlighted = false
        cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
        cell.label.textColor = UIColor(named: K.BrandColors.purple)
    }
    //в случае, если сообщение от другого пользователя:
    else {
        cell.leftImageView.isHidden = false
        cell.rightImageView.isHidden = true
        cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
        cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
    }
    
    return cell

}
}

//существует также протокол UITableViewDelegate. можно дополнительно тспользовать его, но не забываем создать  tableView.delegate = self во ViewDidLoad

/* extension  ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //метод в этом протоколе позволяет взаимодействовать с определенной ячейкой
        print(indexPath.row)
    }
    
}
*/
