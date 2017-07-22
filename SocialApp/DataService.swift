//
//  DataService.swift
//  SocialApp
//
//  Created by Gabriel Trujillo Gómez on 7/17/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

let FIR_DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService
{
    static let instance = DataService()

    private var _REF_BASE = FIR_DB_BASE
    private var _REF_POSTS = FIR_DB_BASE.child("Posts")
    private var _REF_USERS = FIR_DB_BASE.child("Users")
    
    private var _STORAGE_REF_POSTS_IMAGES = STORAGE_BASE.child("posts")
    
    var REF_BASE: DatabaseReference
    {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference
    {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference
    {
        return _REF_USERS
    }
    
    var STORAGE_REF_POSTS_IMAGES: StorageReference
    {
        return _STORAGE_REF_POSTS_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>)
    {
        _REF_USERS.child(uid).updateChildValues(userData)
    }
}
