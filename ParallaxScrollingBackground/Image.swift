//
//  Image.swift
//  ParallaxScrollingBackground
//
//  Created by Doug Whitmore on 3/18/16.
//  Copyright © 2016 Good Doug. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias Image = UIImage
#else
    import AppKit
    typealias Image = NSImage
#endif
