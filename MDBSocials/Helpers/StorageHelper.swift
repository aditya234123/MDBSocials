//
//  StorageHelper.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/21/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import Firebase
import FirebaseStorage

class StorageHelper {
    
    static func uploadMedia(postID: String, image: UIImage, withBlock: @escaping () -> Void) {
        let storage = Storage.storage().reference().child(postID)
        if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
            storage.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                } else {
                    let url = metadata?.downloadURL()?.absoluteString
                    //send url in?
                    withBlock()
                }
            }
        }
        
    }
    
    static func getProfilePic(id: String, withBlock: @escaping (UIImage) -> ()) {
        let ref = Storage.storage().reference().child(id)
        ref.getData(maxSize: 1 * 4096 * 4096) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                withBlock(image!)
            }
        }
    }
    
}
