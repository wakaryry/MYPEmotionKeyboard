//
//  NSAttributedString+Emotion.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/21.
//

import Foundation

internal class MYPEmotionMatchingResult {
    internal var range: NSRange = NSMakeRange(0, 0)
    internal var emojiImage: UIImage? = nil
    internal var description: String
    
    init(range: NSRange, image: UIImage?, description: String) {
        self.range = range
        self.emojiImage = image
        self.description = description
    }
}

public extension NSMutableAttributedString {
    /** 匹配给定attributedString中的所有emoji，如果匹配到的emoji有本地图片的话会直接换成本地的图片*/
    public func translateAttributedTextIntoEmotionText(with font: UIFont?) {
        if self.length == 0 || font == nil {
            return
        }
        print("Translate")
        let results = self.matchingEmotion(in: self.string)
        
        if results != nil && (results?.count ?? 0) > 0 {
            print("Matched")
            var offset = 0
            for result in results! {
                if let image = result.emojiImage {
                    let emotionHeight = font!.lineHeight
                    
                    let attachment = NSTextAttachment()
                    attachment.image = image
                    attachment.bounds = CGRect(x: 0, y: font!.descender, width: emotionHeight, height: emotionHeight)
                    
                    let emotionAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
                    emotionAttributedString.myp_setTextBackedString(result.description, range: NSMakeRange(0, emotionAttributedString.length))
                    
                    let actualRange = NSMakeRange(result.range.location - offset, result.description.distance(from: result.description.startIndex, to: result.description.endIndex))
                    
                    self.replaceCharacters(in: actualRange, with: emotionAttributedString)
                    
                    offset += result.description.distance(from: result.description.startIndex, to: result.description.endIndex) - emotionAttributedString.length
                    print(self)
                }
            }
        }
    }
    
    private func matchingEmotion(in string: String) -> [MYPEmotionMatchingResult]? {
        if string.isEmpty {
            return nil
        }
        
        let regex = try! NSRegularExpression(pattern: "\\[.+?\\]", options: [])
        let results = regex.matches(in: string, options: [], range: NSMakeRange(0, string.count))
        
        if !results.isEmpty {
            var emotionMatchingResults = [MYPEmotionMatchingResult]()
            
            for result in results {
                
                let startIndex = string.index(string.startIndex, offsetBy: result.range.location)
                let endIndex = string.index(string.startIndex, offsetBy: result.range.location + result.range.length)
                let description = String(string[startIndex..<endIndex])
                
                let emotion = self.emotion(with: description)
                if let e = emotion {
                    let range = result.range
                    let image = UIImage(named: e.name, in: MYPEmotionBundle, compatibleWith: nil)!
                    let emotionMatchingResult = MYPEmotionMatchingResult(range: range, image: image, description: description)
                    emotionMatchingResults.append(emotionMatchingResult)
                }
            }
            return emotionMatchingResults
        }
        return nil
    }
    
    private func emotion(with description: String) -> MYPEmotion? {
        for emotion in MYPEmotion.defaultEmotions() {
            if emotion.description == description {
                return emotion
            }
        }
        return nil
    }
}

public extension NSMutableAttributedString {
    public func myp_setTextBackedString(_ string: String?, range: NSRange) {
        if string != nil && !string!.isEmpty {
            self.addAttribute(NSAttributedStringKey.MYPEmotionKey.MYPTextBackedStringAttributeName, value: string!, range: range)
        }
        else {
            self.removeAttribute(NSAttributedStringKey.MYPEmotionKey.MYPTextBackedStringAttributeName, range: range)
        }
    }
}

public extension NSAttributedString {
    public func myp_plainText(in range: NSRange) -> String? {
        if range.location == NSNotFound || range.length == NSNotFound {
            return nil
        }
        var result = String()
        if range.length == 0 {
            return result
        }
        
        let string = self.string
        self.enumerateAttribute(NSAttributedStringKey.MYPEmotionKey.MYPTextBackedStringAttributeName, in: range, options: []) { (value, aRange, stop) in
            let backed = value as! String?
            if backed != nil {
                result.append(backed!)
            }
            else {
                let startIndex = string.index(string.startIndex, offsetBy: aRange.location)
                let endIndex = string.index(string.startIndex, offsetBy: aRange.location + aRange.length)
                result.append(String(string[startIndex..<endIndex]))
            }
        }
        return result
    }
    
    public func plainText() -> String {
        return self.myp_plainText(in: NSMakeRange(0, self.length)) ?? ""
    }
    
    public func myp_rangeOfAll() -> NSRange {
        return NSMakeRange(0, self.length)
    }
}
