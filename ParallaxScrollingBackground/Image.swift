//
//  Image.swift
//  ParallaxScrollingBackground
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright © 2016 Good Doug. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    typealias XPImage = UIImage
#else
    import AppKit
    typealias XPImage = NSImage
#endif
