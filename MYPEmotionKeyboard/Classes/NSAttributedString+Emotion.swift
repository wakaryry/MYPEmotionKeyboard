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

extension NSAttributedString {
    /** 匹配给定attributedString中的所有emoji，如果匹配到的emoji有本地图片的话会直接换成本地的图片*/
    public func translateAttributedTextIntoEmotionText(with font: UIFont?) {
        if self.length == 0 || font == nil {
            return
        }
        
        let results = self.matchingEmotion(in: self.string)
        
        if results != nil && (results?.count ?? 0) > 0 {
            var offset = 0
            for result in results! {
                if let image = result.emojiImage {
                    let emotionHeight = font!.lineHeight
                    
                    let attachment = NSTextAttachment()
                    attachment.image = image
                    attachment.bounds = CGRect(x: 0, y: font!.descender, width: emotionHeight, height: emotionHeight)
                    
                    var emotionAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
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
                let description = String(string[startIndex...endIndex])
                
                let emotion = self.emotion(with: description)
                if let e = emotion {
                    let range = result.range
                    let image = UIImage(named: e.name, in: MYPEmotionBundle, compatibleWith: nil)
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

extension NSMutableAttributedString {
    public func myp_setTextBackedString(_ string: String, range: NSRange) {
        
    }
}
