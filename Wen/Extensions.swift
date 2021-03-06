//
//  Extensions.swift
//  WillYou
//
//  Created by Josh Doman on 12/13/16.
//  Copyright © 2016 Josh Doman. All rights reserved.
//

import UIKit

extension UIView {
    
    @available(iOS 9.0, *)
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    @available(iOS 9.0, *)
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    @available(iOS 9.0, *)
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let warmGrey = UIColor(r: 115, g: 115, b: 115)
    static let maroonRed = UIColor(r: 192, g: 57, b:  43)
    static let whiteGrey = UIColor(r: 248, g: 248, b: 248)
    static let paleTeal = UIColor(r: 149, g: 207, b: 175)
    static let coral = UIColor(r: 242, g: 110, b: 103)
    static let marigold = UIColor(r: 255, g: 193, b: 7)
    static let oceanBlue = UIColor(r: 73, g: 144, b: 226)
    static let frenchBlue = UIColor(r: 63, g: 81, b: 181)
}

extension UIBarButtonItem {
    static func itemWith(colorfulImage: UIImage?, color: UIColor, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.tintColor = color
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}

extension Date {
    func minutesFrom(date: Date) -> Int {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: self, to: date)
        if let hour = difference.hour, let minute = difference.minute {
            return hour*60 + minute
        }
        return 0
    }
    
    //returns date in local time
    static var currentLocalDate: Date {
        get {
            var now = Date()
            var nowComponents = DateComponents()
            let calendar = Calendar.current
            nowComponents.year = Calendar.current.component(.year, from: now)
            nowComponents.month = Calendar.current.component(.month, from: now)
            nowComponents.day = Calendar.current.component(.day, from: now)
            nowComponents.hour = Calendar.current.component(.hour, from: now)
            nowComponents.minute = Calendar.current.component(.minute, from: now)
            nowComponents.second = Calendar.current.component(.second, from: now)
            nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
            now = calendar.date(from: nowComponents)!
            return now as Date
        }
    }
    
    var minutes: Int {
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: self)
        return minutes
    }
    
    static func addMinutes(to date: Date, minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: date)!
    }
    
    private var ends11_59: Bool {
        return minutes == 59
    }
    
    func adjustFor11_59() -> Date {
        if ends11_59 {
            return Date.addMinutes(to: self, minutes: 1)
        }
        return self
    }
    
    var dayOfWeek: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    static func addDay(to date: Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    
    static func addDays(to date: Date, days: Int) -> Date {
        var tempDate = date
        if days <= 0 { return date }
        for _ in 0...(days-1) {
            tempDate = Date.addDay(to: tempDate)
        }
        return tempDate
    }
    
    func isSameDay(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self) == calendar.startOfDay(for: date)
    }
    
    static func isToday(date: Date) -> Bool {
        return Date().isSameDay(date: date)
    }
    
    static func isTomorrow(date: Date) -> Bool {
        return Date.addDay(to: Date()).isSameDay(date: date)
    }
    
    var abbreviation: String {
        let dict = ["Sunday":"Sun", "Monday":"M", "Tuesday":"T", "Wednesday":"W", "Thursday":"Th", "Friday":"F", "Saturday":"Sat"]
        if let day = self.dayOfWeek {
            return dict[day]!
        }
        return ""
    }
}

extension UIFont {
    
    static let normalFont = "HelveticaNeue"
    static let lightFont: String = "HelveticaNeue-Light"
    
}

extension String: Error, LocalizedError {
    public var errorDescription: String? { return self }
}

extension UIImage {
    
    func maskWithColor( color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        color.setFill()
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage!
    }
}

// Definition:
extension Notification.Name {
    static let signedInNotification = Notification.Name("signedInNotification")
}
