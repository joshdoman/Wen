//
//  RegisterOrgPhotoController.swift
//  Wen
//
//  Created by Josh Doman on 4/9/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit
import Material
import FirebaseAuth

class RegisterOrgPhotoController: GeneralRegisterOrganizationController {
    
    var name: String! {
        didSet {
            nameLabel.text = name
        }
    }
    
    let signInButton = GIDSignInButton()
    
    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "org_profile")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.contentMode = .scaleAspectFill
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleAddPhoto))
        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: UIFont.normalFont, size: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let addPhotoButton: FlatButton = {
        let button = FlatButton(title: "Add a photo", titleColor: Color.blue.base)
        button.pulseColor = .white
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    fileprivate let skipNextButton: FlatButton = {
        let button = FlatButton(title: "Skip", titleColor: Color.blue.base)
        button.pulseColor = .white
        button.addTarget(self, action: #selector(handleSkipNext), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.title = "Add photo + login"
        
        GIDSignIn.sharedInstance().uiDelegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signOut() //signs out user
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setupProfileView()
        setupNameLabel()
        setupPhotoButton()
        prepareSignInButton()
    }
    
}

extension RegisterOrgPhotoController {
    
    fileprivate func setupProfileView() {
        view.addSubview(profileImageView)
        _ = profileImageView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 200)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
    }
    
    fileprivate func setupNameLabel() {
        view.addSubview(nameLabel)
        _ = nameLabel.anchor(profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupPhotoButton() {
        view.addSubview(addPhotoButton)
        _ = addPhotoButton.anchor(nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupSkipNextButton() {
        view.addSubview(skipNextButton)
        _ = skipNextButton.anchor(addPhotoButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        skipNextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
    }
    
    fileprivate func prepareSignInButton() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    @objc fileprivate func handleAddPhoto() {
        self.showImagePicker()
    }
    
    @objc fileprivate func handleSkipNext(_ sender: UIButton) {
        
    }
}

extension RegisterOrgPhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Image Picking
    func showImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profileImageView.image = selectedImage
            self.skipNextButton.title = "Next"
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}

extension RegisterOrgPhotoController: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(userSuccessfullySignedIn), name: .signedInNotification, object: nil)
    }
    
}

extension RegisterOrgPhotoController {
    //GoogleManagerDelegate method
    @objc fileprivate func userSuccessfullySignedIn() {
        NotificationCenter.default.removeObserver(self, name: .signedInNotification, object: nil)
        
        guard let user = GIDSignIn.sharedInstance().currentUser else { return }
        let image = profileImageView.image == UIImage(named: "org_profile") ? nil : profileImageView.image
        
        NetworkManager.addGoogleOrganizationToDB(for: user, name: name, photo: image) {
            let soec = SyncOrgEventsController()
            self.navigationController?.pushViewController(soec, animated: true)
        }
    }
}
