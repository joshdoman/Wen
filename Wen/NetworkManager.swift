//
//  NetworkManager.swift
//  Wen
//
//  Created by Josh Doman on 4/7/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//


import FirebaseDatabase
import FirebaseAuth
import GoogleAPIClient
import FirebaseStorage

class NetworkManager {
    
    static func syncGoogleEventsToDatabase(for events: [GTLCalendarEvent], completion: @escaping (_ success: Bool) -> Void) {
        let idRef = FIRDatabase.database().reference().child("events-by-id")
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let ownerRef = FIRDatabase.database().reference().child("events-by-owner").child(uid)
        
        removeAllGoogleEvents(for: uid) { (success) in
            for event in events {
                
                let childRef = idRef.childByAutoId()
                var values = [String: AnyObject]()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                if let startDate = event.start.dateTime ?? event.start.date { values["start"] = dateFormatter.string(from: startDate.date) as AnyObject }
                if let endDate = event.end.dateTime ?? event.end.date { values["end"] = dateFormatter.string(from: endDate.date) as AnyObject }
                if let summary = event.summary { values["summary"] = summary as AnyObject }
                if let location = event.location { values["location"] = location as AnyObject }
                if let iCalUID = event.iCalUID { values["iCalUID"] = iCalUID as AnyObject }
                values["owner"] = uid as AnyObject
                
                //ref.child(eventId).updateChildValues(values)
                childRef.updateChildValues(values)
                ownerRef.updateChildValues([childRef.key : 1])
                ownerRef.updateChildValues([childRef.key : 1])
            }
            completion(success)
        }
    }
    
    private static func removeAllGoogleEvents(for uid: String, completion: @escaping (_ success: Bool) -> Void) {
        let ref = FIRDatabase.database().reference().child("events-by-owner").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : AnyObject] {
                for key in dict.keys {
                    FIRDatabase.database().reference().child("events-by-id").child(key).removeValue()
                    ref.removeValue()
                }
            }
            completion(true)
        })
    }
    
    static func addGoogleOrganizationToDB(for user: GIDGoogleUser, name: String, photo: UIImage?, completion: @escaping () -> Void) {
        completion()
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let profile = user.profile else { return }
        let ref = FIRDatabase.database().reference().child("organizations").child(uid)
        
        var values = [String: AnyObject]()
        
        if let email = profile.email { values["email"] = email as AnyObject }
        values["name"] = name as AnyObject
        if let googleName = profile.name { values["googleName"] = googleName as AnyObject }
        
        if let photo = photo {
            FirebaseNetworkManager.uploadImageToFirebaseStorage(image: photo) { (imageUrl, error) in
                if error != nil {
                    ref.updateChildValues(values)
                    return
                }
                
                if let url = imageUrl {
                    values["imageUrl"] = url as AnyObject
                    ref.updateChildValues(values)
                }
            }
        } else {
            ref.updateChildValues(values)
        }
    }
    
    static func getAllOrganizations(completion: @escaping(_ organizations: [Organization]) -> Void) {
        FIRDatabase.database().reference().child("organizations").observeSingleEvent(of: .value, with: { (snapshot) in
            var organizations = [Organization]()
            if let dict = snapshot.value as? [String : AnyObject] {
                let keys = dict.keys
                var count = 0
                for key in keys {
                    getOrganization(for: key) { (organization) in
                        if let org = organization {
                            organizations.append(org)
                        }
                        count += 1
                        if keys.count == count {
                            completion(organizations) //callback if last key
                        }
                    }
                }
            }
        })
    }
    
    private static func getOrganization(for uid: String, completion: @escaping(_ organization: Organization?) -> Void) {
        FIRDatabase.database().reference().child("organizations").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : AnyObject] {
                guard let email = dict["email"] as? String, let name = dict["name"] as? String else {
                    completion(nil)
                    return
                }
                
                var organization = Organization(uid: uid, name: name, email: email)
                
                if let imageUrl = dict["imageUrl"] as? String {
                    organization.imageUrl = imageUrl
                }
                completion(organization)
            }
        })
    }
}

class FirebaseNetworkManager {
    
    static func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (_ imageUrl: String?, _ error: Error?) -> Void) {
        let imageName = NSUUID().uuidString
        
        let ref = FIRStorage.storage().reference().child("organization_profile_images").child("\(imageName).jpg")
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error!)
                    completion(nil, error)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl, nil)
                }
            })
        }
    }
}
