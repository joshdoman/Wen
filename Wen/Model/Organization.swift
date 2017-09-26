//
//  Organization.swift
//  Wen
//
//  Created by Josh Doman on 4/10/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import Graph

struct Organization {
    let uid: String
    let name: String
    let email: String
    var imageUrl: String?
    
    init(uid: String, name: String, email: String) {
        self.uid = uid
        self.name = name
        self.email = email
    }
    
    public static func addToGraph(_ organization: Organization) {
        let graph = Graph()
        
        let u = Entity(type: "Organization")
        u["name"] = organization.name
        u["email"] = organization.email
        u["uid"] = organization.uid
        
        if let imageUrl = organization.imageUrl {
            u["imageUrl"] = imageUrl
        }
        
        graph.sync()
    }
    
    public static func addToGraph(_ organizations: [Organization]) {
        for organization in organizations {
            addToGraph(organization)
        }
    }
    
    static var following: [Organization] = [Organization]()
}
