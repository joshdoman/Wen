//
//  LeftViewController.swift
//  Wen
//
//  Created by Josh Doman on 4/6/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material
import GoogleAPIClient
import Firebase

struct ButtonLayout {
    struct Flat {
        static let width: CGFloat = 120
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -150
    }
    
    struct Raised {
        static let width: CGFloat = 150
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -75
    }
    
    struct Fab {
        static let diameter: CGFloat = 48
    }
    
    struct Icon {
        static let width: CGFloat = 120
        static let height: CGFloat = 48
        static let offsetY: CGFloat = 75
    }
}


class LeftViewController: UIViewController {
    let signInButton = GIDSignInButton()
    
    let syncButton: RaisedButton = {
        let button = RaisedButton(title: "Sync", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(handleSync(_:)), for: .touchUpInside)
        return button
    }()
    
    let signOutButton: RaisedButton = {
        let button = RaisedButton(title: "Logout", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        return button
    }()
    
    let createButton: RaisedButton = {
        let button = RaisedButton(title: "Create", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(didTapCreate(_:)), for: .touchUpInside)
        return button
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.base
        
        //GIDSignIn.sharedInstance().delegate = self
        
        view.backgroundColor = .white
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        prepareSyncButton()
        prepareSignOutButton()
        prepareCreateButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self

        if GIDSignIn.sharedInstance().currentUser == nil && GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently() //sign user in silently
        }
    }
    
    func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func didTapCreate(_ sender: AnyObject) {
        closeNavigationDrawer(result: true)
        let navVC = CreateNavigationController(rootViewController: RegisterOrgNameController())
        navigationDrawerController?.transition(to: navVC, completion: nil)
    }
    
    internal func syncGoogleEvents() {        
        GoogleNetworkManager.getEvents { (events, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let events = events {
                for event in events {
                    let start : GTLDateTime! = event.start.dateTime ?? event.start.date
                    let startString = DateFormatter.localizedString(
                        from: start.date,
                        dateStyle: .short,
                        timeStyle: .short
                    )
                    
                    let end : GTLDateTime! = event.end.dateTime ?? event.end.date
                    let endString = DateFormatter.localizedString(
                        from: end.date,
                        dateStyle: .short,
                        timeStyle: .short
                    )
                    
                    print(startString)
                    print(endString)
                    print(event.summary)
                }
                NetworkManager.syncGoogleEventsToDatabase(for: events) { (success) in
                    
                }
            }
        }
    }
}

extension LeftViewController {
    fileprivate func prepareSyncButton() {
        view.layout(syncButton)
            .width(ButtonLayout.Raised.width)
            .height(ButtonLayout.Raised.height)
            .center(offsetY: ButtonLayout.Raised.offsetY)
    }
    
    fileprivate func prepareSignOutButton() {
        view.addSubview(signOutButton)
        
        _ = signOutButton.anchor(syncButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 100, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: ButtonLayout.Raised.width, heightConstant: ButtonLayout.Raised.height)
        signOutButton.centerXAnchor.constraint(equalTo: syncButton.centerXAnchor).isActive = true
    }
    
    fileprivate func prepareCreateButton() {
        view.addSubview(createButton)
        
        _ = createButton.anchor(nil, left: nil, bottom: syncButton.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 50, rightConstant: 0, widthConstant: ButtonLayout.Raised.width, heightConstant: ButtonLayout.Raised.height)
        createButton.centerXAnchor.constraint(equalTo: syncButton.centerXAnchor).isActive = true    }
}

extension LeftViewController {
    fileprivate func closeNavigationDrawer(result: Bool) {
        navigationDrawerController?.closeLeftView()
    }
    
    internal func handleSync(_ sender: UIButton) {
        if GIDSignIn.sharedInstance().currentUser == nil {
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                GIDSignIn.sharedInstance().signInSilently() //sign user in silently
            } else {
                signInButton.sendActions(for: .touchUpInside) //Ask user to sign in
            }
        } else {
            syncGoogleEvents()
        }
    }
}

extension LeftViewController: GIDSignInUIDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        syncGoogleEvents()
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.sign(inWillDispatch: signIn, error: nil)
        navigationDrawerController?.transition(to: viewController)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.sign(inWillDispatch: signIn, error: nil)
        navigationDrawerController?.dismiss(animated: true, completion: nil)
    }
    
}
