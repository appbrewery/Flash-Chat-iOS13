

# Sun-Chatz

## Project Goal

One of the most fundamental component of modern iOS apps is the Table View. Table Views are used everywhere from the Mail app to the Messages app, so it’s a crucial part of every iOS developer’s tool belt. In this project, I’ll be getting to grips with Table Views, creating custom cells, and making my own cloud-based backend database using FireBase.

## What the Project is

I will be using Firebase Firestore as a backend database to store and retrieve our messages from the cloud and emulate a messaging app similar to Whatsapp.

## What I've learned

* How to integrate third party libraries in your app using Cocoapods/Swift Package Manager.
* How to store data in the cloud using Firebase Firestore.
* How to query and sort the Firebase database.
* How to use Firebase for user authentication, registration and login.
* How to work with UITableViews and how to set their data sources and delegates.
* How to create custom views using .xib files to modify native design components.
* How to embed View Controllers in a Navigation Controller and understand the navigation stack.
* How to create a constants file and use static properties to store Strings and other constants.
* Learn about Swift loops and create animations using loops.
* Learn about the App Lifecycle and how to use viewWillAppear or viewWillDisappear.
* How to create direct Segues for navigation.


# Constants
```
struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

```
>This is a companion project to The App Brewery's Complete App Developement Bootcamp

![App Brewery Banner](Documentation/AppBreweryBanner.png)