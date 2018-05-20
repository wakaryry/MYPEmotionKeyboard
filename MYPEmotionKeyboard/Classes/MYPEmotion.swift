//
//  MYPEmotion.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/19.
//

import Foundation

public class MYPEmotion {
    /** image name*/
    public var name: String
    /** text*/
    public var description: String
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    init(fromDictionary dictionary: NSDictionary){
        let imageText = dictionary["image"] as! String
        self.name = imageText
        self.description = dictionary["text"] as! String
    }
    
    class func defaultEmotions() -> [MYPEmotion] {
        var emotions = [MYPEmotion]()
        let emotionData = NSArray(contentsOfFile: (MYPEmotionBundle?.path(forResource: "Expression", ofType: "plist")!)!)!
        
        for item in emotionData {
            let emotion = MYPEmotion(fromDictionary: item as! NSDictionary)
            emotions.append(emotion)
        }
        return emotions
    }
}
