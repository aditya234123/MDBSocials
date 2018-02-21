//
//  UserAuthHelper.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/19/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import Firebase

class UserAuthHelper {

    static func logIn(email: String, password: String, withBlock: @escaping (User?, String)->()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user: User?, error) in
            if error == nil {
                withBlock(user, "")
            } else {
                withBlock(nil, (error?.localizedDescription)!)
            }
        })
    }
    
    static func logOut(withBlock: @escaping ()->()) {
        print("logging out")
        //TODO: Log out using Firebase!
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            withBlock()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func createUser(email: String, password: String, withBlock: @escaping (User?, String) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error == nil {
                withBlock(user, "")
            }
            else {
                print(error.debugDescription)
                withBlock(user, (error?.localizedDescription)!)
            }
        })
    }
    
    
    static func isUserLoggedIn(withBlock: @escaping (User) -> ()) {
        let listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                //can only be logged in on the initial time. Fixes some memory issues!
                withBlock(user)

            } else {
                // user is not logged in
            }
        }
        Auth.auth().removeStateDidChangeListener(listener)
        
    }
    
    static func getCurrentUser(withBlock: @escaping (User) -> ()) {
        withBlock(Auth.auth().currentUser!)
    }
    
    
    
    
}
