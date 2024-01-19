//
//  RichEditorDelegate.swift
//  RichEditor
//
//  Created by William Lumley on 18/1/2022.
//

import Foundation

public protocol RichEditorDelegate {

    func fontStylingChanged(_ textStyling: TextStyling)
    func richEditorTextChanged(_ richEditor: RichEditor)

}
