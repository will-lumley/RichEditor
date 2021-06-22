//
//  NSMenu+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 1/4/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

public extension NSMenu {

    static func fontsMenu(with title: String = "Select a Font Family") -> NSMenu {
        let menu = NSMenu(title: title)
        
        let allFontFamilyNames = NSFontManager.shared.availableFontFamilies
        for fontName in allFontFamilyNames {
            
            let font       = NSFont(name: fontName, size: NSFont.systemFontSize)!
            let attributes = [NSAttributedString.Key.font: font]
            let attrStr    = NSAttributedString(string: fontName, attributes: attributes)
            
            let menuItem = NSMenuItem()
            menuItem.attributedTitle = attrStr
            
            menu.addItem(menuItem)
        }
        
        return menu
    }
    
    static func fontSizesMenu(with title: String = "Select a Font Size") -> NSMenu {
        let menu = NSMenu(title: title)
        
        let allFontSizes = ["9", "10", "11", "12", "13", "14", "18", "24", "36", "48", "64", "72", "96", "144", "288"]
        for fontSize in allFontSizes {
            
            let font       = NSFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedString.Key.font: font]
            let attrStr    = NSAttributedString(string: fontSize, attributes: attributes)
            
            let menuItem = NSMenuItem()
            menuItem.attributedTitle = attrStr
            
            menu.addItem(menuItem)
        }
        
        return menu
    }

}
