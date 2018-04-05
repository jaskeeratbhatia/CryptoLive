//
//  ProfileViewController.swift
//  CryptoLive
//
//  Created by Jaskeerat Singh Bhatia on 2018-03-22.
//  Copyright © 2018 jaskeeratbhatia. All rights reserved.
//

import UIKit
import Fusuma
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ProfileViewController: UIViewController, FusumaDelegate {
   
    
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seperatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var zoomedInProfileImage: UIImageView!
    @IBOutlet var zoomInProfilePicView: UIView!

    @IBOutlet weak var visualEffect: UIVisualEffectView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    var effect : UIVisualEffect!
    var userStorage : StorageReference!
    var databaseRef : DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = visualEffect.effect
        visualEffect.effect = nil
        visualEffect.isUserInteractionEnabled = false
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        profileImage.layer.borderWidth = 3
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
      
        profileView.layer.shadowColor = UIColor(white: 0.3, alpha: 0.5).cgColor
        profileView.layer.shadowRadius = 15
        profileView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileView.layer.shadowOpacity = 0.8
        
        
        let storage = Storage.storage().reference(forURL: "gs://cryptolive-39961.appspot.com")
        userStorage = storage.child("users")
        databaseRef = Database.database().reference()
        fetchDatafromFirebase()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        
        // add it to the image view;
        profileImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        profileImage.isUserInteractionEnabled = true
        
        seperatorViewLeadingConstraint.constant = 500
        profileViewHeightConstraint.constant = 0
       
        perform(#selector(loadAnimatedUI), with: nil, afterDelay: 0.5)

        
    }
    
    func fetchDatafromFirebase(){
        
        databaseRef.child("users").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, AnyObject>{
                for (uid, data) in value {
                    if uid == Auth.auth().currentUser?.uid{
                        self.nameLabel.text = data["name"] as! String
                        self.emailLabel.text = data["email"] as! String
                        self.profileImage.downloadImage(from: (data["profileImageUrl"] as! String))
                    }
                }
                self.databaseRef.removeAllObservers()
            }
        }
        
    }
    
   func  updateUserProfileImage(){
    
    var profileImageUrl = ""
    
    let userID = Auth.auth().currentUser?.uid as! String
    let imageRef = self.userStorage.child("\(userID).jpg")
    
    let data = UIImageJPEGRepresentation(self.zoomedInProfileImage.image!, 0.5 )
   
    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
        if let err = err {
            print("*****************")
            print(err.localizedDescription)
        }
        imageRef.downloadURL(completion: { (url, er) in
            if let er = er {
                print("=====================")
                print(er.localizedDescription)
                
            }
            //let dict = ["profileImageUrl" : profileImageUrl]
            profileImageUrl = (url?.absoluteString)!
            print("DP URL : ",profileImageUrl)
            self.databaseRef.child("users").child(Auth.auth().currentUser?.uid as! String).child("profileImageUrl").setValue(profileImageUrl, andPriority: nil)
        })
       
    })
     uploadTask.resume()
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            animateInSubView()
   
        }
    }
    
    @objc func loadAnimatedUI(){
        
        UIView.animate(withDuration: 0.5, animations: {
            //self.aboutHeadingLabel.text = "About"
            self.seperatorViewLeadingConstraint.constant = 20
            self.profileViewHeightConstraint.constant = 300
            
            let scale = CGAffineTransform.identity
            let rotate = CGAffineTransform(rotationAngle:  CGFloat(Double.pi) )
            let mixTransform = scale.concatenating(rotate)
//            self.profileImage.transform = CGAffineTransform.identity
//            self.profileImage.transform = CGAffineTransform(rotationAngle: (2 * CGFloat.pi))
            self.profileImage.transform = mixTransform

            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseIn, animations: { () -> Void in
            self.profileImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2))
        }, completion: nil)
        }
    

    
    
    func animateInSubView(){
    self.view.addSubview(zoomInProfilePicView)
        zoomInProfilePicView.center = self.view.center
        zoomedInProfileImage.image = profileImage.image
        zoomInProfilePicView.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
        zoomInProfilePicView.alpha = 0
        self.visualEffect.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffect.effect = self.effect
            self.zoomInProfilePicView.alpha = 1
            self.zoomInProfilePicView.transform = CGAffineTransform.identity
            
        }
    }
    
    func animateOutSubView () {
        UIView.animate(withDuration: 0.4, animations: {
            self.zoomInProfilePicView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.zoomInProfilePicView.alpha = 0
            
            self.visualEffect.effect = nil
            self.visualEffect.isUserInteractionEnabled = false
            
        }) { (success:Bool) in
            self.zoomInProfilePicView.removeFromSuperview()
            self.profileImage.image = self.zoomedInProfileImage.image
        }
        
        updateUserProfileImage()
    }
  
    @IBAction func onPressSubViewCancel(_ sender: Any) {
        
        animateOutSubView()
    }
    
    @IBAction func onPressSubViewEdit(_ sender: Any) {
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        //fusuma.hasVideo = true //To allow for video capturing with .library and .camera available by default
        fusuma.cropHeightRatio = 1 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        //fusuma.allowMultipleSelection = true // You can select multiple photos from the camera roll. The default value is false.
        self.present(fusuma, animated: true, completion: nil)
        

    }

    
    
    
    @IBAction func onPressCancel(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        zoomedInProfileImage.image = image
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        print("Camera Error")
    }
    


}
