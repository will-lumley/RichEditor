//
//  CIImage+Conversion.swift
//  RichEditor
//
//  Created by William Lumley on 15/1/2022.
//

import Foundation
import CoreImage

internal extension CIImage {

    var cgImage: CGImage? {
        CIContext(options: nil).createCGImage(self, from: self.extent)
    }

}

