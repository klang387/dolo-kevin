//
//  UITextViewExt.swift
//  DoloChallenge
//
//  Created by Kevin Langelier on 2/27/18.
//  Copyright © 2018 Kevin Langelier. All rights reserved.
//

import UIKit

// Returns number of lines to ensure HeadlineTextView of NewPostVC can expand, but no more than 3 lines

extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
