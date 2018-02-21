//
//  FirebaseAPIClient.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/21/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import Firebase
import FirebaseDatabase

class FirebaseAPIClient {

    static func createNewUser(id: String, name: String, email: String, username: String) {
        let usersRef = Database.database().reference().child("Users")
        let newUser = ["name": name, "email": email, "username": username]
        let childUpdates = ["/\(id)/": newUser]
        usersRef.updateChildValues(childUpdates)
    }
    
    static func createNewPost(person: String, eventName: String, date: String, description: String, withBlock: @escaping (String) -> ()) {
        let ref = Database.database().reference()
        let key = ref.child("Posts").childByAutoId().key
        let post = ["Person": person, "Event": eventName, "RSVP": 0, "Date": date, "Description": description] as [String : Any]
        let childUpdates = ["/Posts/\(key)": post]
        ref.updateChildValues(childUpdates)
        withBlock(key)
    }
    
    static func fetchUser(id: String, withBlock: @escaping (NSDictionary) -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = Database.database().reference()
        ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            withBlock(dict!)
            
        })
    }
    
    static func fetchPosts(withBlock: @escaping (Post) -> ()) {
        //TODO: Implement a method to fetch posts with Firebase!
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            withBlock(post)
        })
    }
    
}
