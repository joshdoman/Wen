//
//  RootViewController.swift
//  Wen
//
//  Created by Josh Doman on 4/9/17.
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
import Graph

class OrganizationSearchController: UIViewController {
    // Model.
    internal var graph: Graph = {
        let graph = Graph()
        graph.clear() //clears the graph
        return graph
    }()
    
    internal var search: Search<Entity>!
    
    // View.
    internal var tableView: UserTableView = UserTableView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
                
        // Prepare view.
        prepareSearchBar()
        prepareTableView()
    
        fetchAndAddOrganizations()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.reloadData()
    }
    
    var tableViewHeightAnchor: NSLayoutConstraint?
    var tableViewHeight: CGFloat {
        return view.bounds.height
    }
    
    func fetchAndAddOrganizations() {
        NetworkManager.getAllOrganizations { (organizations) in
            print(organizations)
            Organization.addToGraph(organizations)
            
            DispatchQueue.main.async {
            }
            // Prepare model.
            self.prepareSearch()
        }
    }
}

/// Model.
extension OrganizationSearchController {
    internal func prepareSearch() {
        search = Search<Entity>(graph: graph).for(types: "Organization").where(properties: "name")
        
        search.async { [weak self] (data) in
            self?.reloadData()
        }
    }
    
    internal func prepareTableView() {
        view.addSubview(tableView)
        
        _ = tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        tableViewHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightAnchor?.isActive = true
    }
    
    internal func reloadData() {
        tableView.data = search.sync().sorted(by: { (a, b) -> Bool in
            guard let n = a["name"] as? String, let m = b["name"] as? String else {
                return false
            }
            return n < m
        })
    }
    
    internal func animate() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// View.
extension OrganizationSearchController: SearchBarDelegate, UITextFieldDelegate {
    internal func prepareSearchBar() {
        // Access the searchBar.
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
        
        searchBar.delegate = self
        searchBar.textField.delegate = self
    }
    
    func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?) {
        reloadData()
        searchBar.endEditing(true)
        tableViewHeightAnchor?.constant = 0
        animate()
    }
    
    func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?) {
        guard let pattern = text?.trimmed, 0 < pattern.utf16.count else {
            reloadData()
            return
        }
        
        search.async { [weak self, pattern = pattern] (users) in
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                return
            }
            
            var data = [Entity]()
            
            for user in users {
                if let name = user["name"] as? String {
                    let matches = regex.matches(in: name, range: NSRange(location: 0, length: name.utf16.count))
                    if 0 < matches.count {
                        data.append(user)
                    }
                }
            }
            
            self?.tableView.data = data
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableViewHeightAnchor?.constant = tableViewHeight
        animate()
    }
}

class UserTableView: UITableView {
    public var data = [Entity]() {
        didSet {
            reloadData()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    public init() {
        super.init(frame: .zero, style: .plain)
        prepare()
    }
    
    /// Prepares the tableView.
    private func prepare() {
        register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        dataSource = self
        delegate = self
        separatorStyle = .none
    }
}

/// UITableViewDataSource.
extension UserTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let user = data[indexPath.row]
        
        cell.textLabel?.text = user["name"] as? String
        cell.imageView?.image = user["photo"] as? UIImage
        cell.detailTextLabel?.text = user["status"] as? String
        cell.dividerColor = Color.grey.lighten3
        
        return cell
    }
}

/// UITableViewDelegate.
extension UserTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.divider.reload()
    }
}
