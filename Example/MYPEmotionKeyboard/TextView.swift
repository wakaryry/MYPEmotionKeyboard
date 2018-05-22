//
//  TextView.swift
//  MYPEmotionKeyboard_Example
//
//  Created by wakary redou on 2018/5/22.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class TextView: UITextView {
    override func cut(_ sender: Any?) {
        let string = self.attributedText.myp_plainText(in: self.selectedRange) ?? ""
        
        if !string.isEmpty {
            UIPasteboard.general.string = string
            
            let selectedRange = self.selectedRange
            let attributedContent = NSMutableAttributedString(attributedString: self.attributedText)
            attributedContent.replaceCharacters(in: self.selectedRange, with: "")
            self.attributedText = attributedContent
            
            self.selectedRange = NSMakeRange(selectedRange.location, 0)
            
            self.delegate?.textViewDidChange!(self)
        }
    }
    
    override func copy(_ sender: Any?) {
        let string = self.attributedText.myp_plainText(in: self.selectedRange)
        if !(string?.isEmpty ?? true) {
            UIPasteboard.general.string = string
        }
    }
    
    override func paste(_ sender: Any?) {
        let string = UIPasteboard.general.string
        
        if !(string?.isEmpty ?? true) {
            let attributedPasteString = NSMutableAttributedString(string: string!)
            attributedPasteString.translateAttributedTextIntoEmotionText(with: self.font)
            
            let selectedRange = self.selectedRange
            
            var attributeContent: NSMutableAttributedString? = nil
            if let aText = self.attributedText {
                attributeContent = NSMutableAttributedString(attributedString: aText)
            }
            attributeContent?.replaceCharacters(in: self.selectedRange, with: attributedPasteString)
            self.attributedText = attributeContent
            self.selectedRange = NSRange(location: selectedRange.location + attributedPasteString.length, length: 0)
            
            self.delegate?.textViewDidChange!(self)
        }
    }
}
