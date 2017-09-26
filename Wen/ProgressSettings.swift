//
//  ProgressSettings.swift
//  Wen
//
//  Created by Josh Doman on 4/9/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import GradientCircularProgress


public struct ProgressStyle: StyleProperty {
    // Progress Size
    public var progressSize: CGFloat = 260
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 4.0
    public var startArcColor: UIColor = ColorUtil.toUIColor(r: 235.0, g: 245.0, b: 255.0, a: 1.0)
    public var endArcColor: UIColor = ColorUtil.toUIColor(r: 0.0, g: 122.0, b: 255.0, a: 1.0)
    
    // Base Circular
    public var baseLineWidth: CGFloat? = 4.0
    public var baseArcColor: UIColor? = ColorUtil.toUIColor(r: 215.0, g: 215.0, b: 215.0, a: 0.4)
    
    // Ratio
    public var ratioLabelFont: UIFont? = nil
    public var ratioLabelFontColor: UIColor? = nil
    
    // Message
    public var messageLabelFont: UIFont? = UIFont.systemFont(ofSize: 16.0)
    public var messageLabelFontColor: UIColor? = UIColor.warmGrey
    
    // Background
    public var backgroundStyle: BackgroundStyles = .extraLight
    
    // Dismiss
    public var dismissTimeInterval: Double? = nil // 'nil' for default setting.
    
    public init() {}
}
