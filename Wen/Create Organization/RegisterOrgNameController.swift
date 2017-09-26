//
//  CreateOrganizationViewController.swift
//  Wen
//
//  Created by Josh Doman on 4/8/17.
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

class RegisterOrgNameController: GeneralRegisterOrganizationController {
    fileprivate var nameField: ErrorTextField!
    
    fileprivate let nextButton: FlatButton = {
        let button = FlatButton(title: "Next", titleColor: Color.blue.base)
        button.pulseColor = .white
        button.addTarget(self, action: #selector(handleNext(_:)), for: .touchUpInside)
        return button
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareNavigationItem()
        prepareNameField()
        prepareNextButton()
        showBackButton = true
    }
}

extension RegisterOrgNameController {
    override func prepareNavigationItem() {
        super.prepareNavigationItem()
        //navigationItem.title = "Register Organization"
    }
    
    fileprivate func prepareNameField() {
        nameField = ErrorTextField()
        nameField.placeholder = "Name"
        nameField.detail = "Your organization's name"
        nameField.detail = "Error, name must be non-empty"
        
        view.addSubview(nameField)
        
        _ = nameField.anchor(nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        nameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -180).isActive = true
    }
    
    fileprivate func prepareNextButton() {
        view.addSubview(nextButton)
        
        _ = nextButton.anchor(nameField.bottomAnchor, left: nil, bottom: nil, right: nameField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: ButtonLayout.Flat.width, heightConstant: ButtonLayout.Flat.height)
    }
}

extension RegisterOrgNameController {
    @objc
    internal override func handleBack(_ sender: UIButton) {
        nameField.resignFirstResponder()
        navigationDrawerController?.transition(to: AppSearchBarController(rootViewController: ScheduleController()), completion: nil)
    }
    
    @objc fileprivate func handleNext(_ sender: UIButton) {
        if nameField.isEmpty {
            nameField.isErrorRevealed = true
        } else if let text = nameField.text, text.trimmingCharacters(in: .whitespaces).isEmpty {
            nameField.isErrorRevealed = true
        } else {
            let ropc = RegisterOrgPhotoController()
            ropc.name = nameField.text
            navigationController?.pushViewController(ropc, animated: true)
        }
    }
}
