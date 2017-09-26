//
//  GoogleViewController.swift
//  Wen
//
//  Created by Josh Doman on 4/6/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import GoogleAPIClient
import UIKit

class GoogleNetworkManager {
    static let service = GTLServiceCalendar()

    static func getEvents(callback: @escaping ([GTLCalendarEvent]?, _ error: Error?) -> Void) {
        guard let user = GIDSignIn.sharedInstance().currentUser else {
            do {
                throw NSError(domain: "Not Signed In", code: 001, userInfo: nil)
            } catch {
                callback(nil, error)
            }
            return
        }
        
        service.authorizer = user.authentication.fetcherAuthorizer() //get authorization token
        
        if let authorizer = service.authorizer,
            let canAuth = authorizer.canAuthorize, canAuth {
            fetchEvents(callback: callback)
        } else {
            do {
                throw NSError(domain: "Could not authorize", code: 002, userInfo: nil)
            } catch {
                callback(nil, error)
            }
        }
    }
    
    private static func fetchEvents(callback: @escaping ([GTLCalendarEvent]?, _ error: Error?) -> Void) {
        let query = GTLQueryCalendar.queryForEventsList(withCalendarId: "primary")
        query?.maxResults = 10
        query?.timeMin = GTLDateTime(date: NSDate() as Date!, timeZone: NSTimeZone.local)
        query?.singleEvents = true
        query?.orderBy = kGTLCalendarOrderByStartTime

        service.executeQuery(query!) { (ticket, response, error) in
            if let error = error {
                callback(nil, error)
                return
            }
            
            guard let response = response as? GTLCalendarEvents else {
                return
            }
            
            if let events = response.items() {
                if let events = events as? [GTLCalendarEvent] {
                    callback(events, nil)
                }
            }
        }
    }
}
