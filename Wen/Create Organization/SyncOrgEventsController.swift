//
//  SyncOrgEventsController.swift
//  Wen
//
//  Created by Josh Doman on 4/9/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit
import Material
import GoogleAPIClient
import GradientCircularProgress

class SyncOrgEventsController: GeneralRegisterOrganizationController {
    fileprivate let syncButton: RaisedButton = {
        let button = RaisedButton(title: "Sync", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        button.addTarget(self, action: #selector(handleSync(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate let denyButton: FlatButton = {
        let button = FlatButton(title: "No thanks", titleColor: Color.blue.base)
        button.pulseColor = .white
        button.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        return button
    }()
    
    fileprivate let syncLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: UIFont.lightFont, size: 20)
        label.textColor = UIColor.warmGrey
        label.numberOfLines = 2
        label.textAlignment = .right
        label.text = "Would you like to sync your Google Calendar events now?"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "Return to homepage"

        navigationItem.backButton.addTarget(self, action: #selector(handleBack(_:)), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        prepareSyncLabel()
        prepareSyncButton()
        prepareDenyButton()
    }
    
}

extension SyncOrgEventsController {
    
    fileprivate func prepareSyncLabel() {
        view.addSubview(syncLabel)
        
        _ = syncLabel.anchor(nil, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 100, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        syncLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func prepareSyncButton() {
        view.addSubview(syncButton)
        
        _ = syncButton.anchor(syncLabel.bottomAnchor, left: nil, bottom: nil, right: syncLabel.rightAnchor, topConstant: 40, leftConstant: 50, bottomConstant: 0, rightConstant: -16, widthConstant: 100, heightConstant: 40)
    }
    
    fileprivate func prepareDenyButton() {
        view.addSubview(denyButton)
        
        _ = denyButton.anchor(nil, left: nil, bottom: nil, right: syncButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: -30, widthConstant: ButtonLayout.Flat.width, heightConstant: ButtonLayout.Raised.height)
        denyButton.centerYAnchor.constraint(equalTo: syncButton.centerYAnchor).isActive = true
    }
    
    internal func handleSync(_ sender: UIButton) {
        let progress = GradientCircularProgress()
        
        let frame = CGRect(x: view.frame.width/2.0 - 75, y: view.frame.height/2 - 75, width: 150, height: 150)
        let progressView = progress.show(frame: frame, message: "Syncing...", style: BlueDarkStyle())
        view.addSubview(progressView!)
        
        syncGoogleEvents() { (success) in
            let msg = success ? "Success!" : "Uh oh! Failed to sync."
            progress.updateMessage(message: msg)
            
            let when = DispatchTime.now() + 1.2
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                progress.dismiss(progress: progressView!)
                self.returnHome()
            })
        }
    }
    
    internal override func handleBack(_ sender: UIButton) {
        returnHome()
    }
    
    internal func handleExit(_ sender: UIButton) {
        self.handleBack(sender)
    }
    
    internal func returnHome() {
       navigationDrawerController?.transition(to: AppSearchBarController(rootViewController: ScheduleController()), completion: nil)
    }
}

extension SyncOrgEventsController {
    internal func syncGoogleEvents(completion: @escaping (_ success: Bool) -> Void) {
        GoogleNetworkManager.getEvents { (events, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            if let events = events {
                NetworkManager.syncGoogleEventsToDatabase(for: events) { (success) in
                    completion(success)
                }
            }
        }
    }
}
