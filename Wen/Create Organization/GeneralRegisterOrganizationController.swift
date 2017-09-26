//
//  GeneralRegisterOrganizationController.swift
//  Wen
//
//  Created by Josh Doman on 4/8/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit
import Material

class GeneralRegisterOrganizationController: UIViewController {
    fileprivate var backButton: IconButton!

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareBackButton()
        prepareNavigationItem()
    }
    
    var showBackButton: Bool = false {
        didSet {
            if showBackButton {
                navigationItem.leftViews = [backButton]
            }
        }
    }
}

extension GeneralRegisterOrganizationController {
    fileprivate func prepareBackButton() {
        backButton = IconButton(image: Icon.arrowBack, tintColor: .white)
        backButton.addTarget(self, action: #selector(handleBack(_:)), for: .touchUpInside)
        backButton.pulseColor = .white
    }
    
    func prepareNavigationItem() {
        //navigationItem.title = "Register Organization"
        navigationItem.titleLabel.textColor = .white
        navigationItem.titleLabel.textAlignment = .left
    }
}

extension GeneralRegisterOrganizationController {
    func handleBack(_ sender: UIButton) { }
}
