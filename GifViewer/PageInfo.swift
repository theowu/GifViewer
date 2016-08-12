//
//  PageInfo.swift
//  GifViewer
//
//  Created by Theo WU on 18/05/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import Foundation
import AppKit

class PageInfo: NSObject {
    var number: Int
    var name: String
    var image: NSImage?
    
    override init(){
        self.number = 0
        self.name = ""
    }
    
    init(number: Int, name: String, image: NSImage?) {
        self.number = number
        self.name = name
        self.image = image
    }
}
