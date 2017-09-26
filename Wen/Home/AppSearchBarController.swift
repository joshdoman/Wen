//
//  AppSearchBarController.swift
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

class AppSearchBarController: SearchBarController {
    fileprivate var menuButton: IconButton!
    fileprivate var addButton: IconButton!
    
    open override func prepare() {
        super.prepare()
        prepareMenuButton()
        prepareAddButton()
        prepareStatusBar()
        prepareSearchBar()
    }
}

extension AppSearchBarController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.addTarget(self, action: #selector(handleMenu), for: .touchUpInside)
    }
    
    fileprivate func prepareAddButton() {
        addButton = IconButton(image: Icon.cm.add)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
    }
    
    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
        
        // Access the statusBar.
        //        statusBar.backgroundColor = Color.grey.base
    }
    
    fileprivate func prepareSearchBar() {
        searchBar.leftViews = [menuButton]
        searchBar.rightViews = [addButton]
        //searchBar.delegate = self
    }
}

extension AppSearchBarController {
    func handleMenu(_ sender: UIButton) {
        navigationDrawerController?.toggleLeftView()
        searchBar.endEditing(true)
    }
    func handleAdd(_ sender: UIButton) {
        guard let sc = rootViewController! as? ScheduleController else { return }
        sc.handleAdd(sender)
    }
}

//extension AppSearchBarController: SearchBarDelegate {
//    func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?) {
//        searchBar.endEditing(true)
//    }
//}
