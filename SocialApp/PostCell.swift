//
//  PostCell.swift
//  SocialApp
//
//  Created by Gabriel Trujillo Gómez on 7/17/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import UIKit
import FirebaseStorage

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postDescLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post, img: UIImage? = nil)
    {
        self.post = post
        captionLabel.text = post.caption
        likesLabel.text = "\(post.likes)"
    
        if let img = img
        {
            self.postImg.image = img
        }
        else
        {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil
                {
                    print("ERROR: Unable to download img from storage")
                }
                else
                {
                    print("Image Downloaded from Storage")
                    if let imgData = data
                    {
                        if let img = UIImage(data: imgData)
                        {
                            self.postImg.image = img
                            FeedVC.imgCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
}
