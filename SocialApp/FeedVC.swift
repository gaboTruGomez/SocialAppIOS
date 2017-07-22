//
//  FeedVC.swift
//  SocialApp
//
//  Created by Gabriel Trujillo Gómez on 7/16/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageView: RoundedImg!
    
    private var posts = [Post]()
    private var imagePicker: UIImagePickerController!
    static var imgCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let nib = UINib(nibName: "PostCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostCell")
        
        DataService.instance.REF_POSTS.observe(.value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]
            {
                for snap in snapshots
                {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any>
                    {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func facebbokLogOutButtonPressed(_ sender: Any)
    {
        KeychainWrapper.standard.removeObject(forKey: USER_UID_KEY)
        do
        {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "SignInVC", sender: nil)
        }
        catch let error as NSError
        {
            print("Error signing out \(error)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
        {
            //var img: UIImage
            
            if let img = FeedVC.imgCache.object(forKey: post.imageUrl as NSString)
            {
                cell.configureCell(post: post, img: img)
            }
            else
            {
                cell.configureCell(post: post)
            }
            
            return cell
        }
        
        return PostCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            addImageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
        }
        else
        {
            print("ERROR: Valid image wasn't selected")
        }
    }
}
