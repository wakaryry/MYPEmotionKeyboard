
[![Version](https://img.shields.io/cocoapods/v/MYPEmotionKeyboard.svg?style=flat)](https://cocoapods.org/pods/MYPEmotionKeyboard)
[![License](https://img.shields.io/cocoapods/l/MYPEmotionKeyboard.svg?style=flat)](https://cocoapods.org/pods/MYPEmotionKeyboard)
[![Platform](https://img.shields.io/cocoapods/p/MYPEmotionKeyboard.svg?style=flat)](https://cocoapods.org/pods/MYPEmotionKeyboard)

![Emotion Keyboard](https://github.com/wakaryry/MYPEmotionKeyboard/blob/master/screens/surface.png)

## Features
- supported big picture emotion from yourself
- nice user interaction
- allow delete and continuous delete
- example for cut\paste\copy
- text and emotion keyboard
- default small emotions for text
- attributed and plain string output
- emotion shows directly in textview

## How to use
### Installation

MYPEmotionKeyboard is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MYPEmotionKeyboard'
```
### Use
**Init and config**
``` swift
// first import the module
import MYPEmotionKeyboard

override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // MYPEmotionKeyboardView is the default emotion keyboard
    self.emotionView = MYPEmotionKeyboardView
    // set delegate to your controller. MYPEmotionInputDelegate
    self.emotionView?.delegate = self

    // forbidden the drag interaction for emotion in text
    if #available(iOS 11.0, *) {
        self.textView.textDragInteraction?.isEnabled = false
    }
}
```

**Delegate Implement**
``` swift
public protocol MYPEmotionInputDelegate: class {
    func emotionView(_ emotionView: MYPEmotionView, didClickEmotion emotion: MYPEmotion, isDefault: Bool)
    func emotionViewdidClickDelete(_ emotionView: MYPEmotionView)
}
```

**Need big emotions?**
``` swift
// Just to set 'self.emotionView.emotionSet'
```

You need know
`MYPEmotion` class is for the emotion. `MYPEmotionSet` is a set of serial emotions.

And the emotion description is `[smile]` style. We use regex matching for `[XX]` style text.

`public func translateAttributedTextIntoEmotionText(with font: UIFont?)` will output attributedString with emotion attachments.

`public func plainText() -> String` will output plain text with emotion description.

**call keyboard**
``` swift
if condition {
    // emotion keyboard
    self.textView.inputView = self.emotionView
    self.textView.reloadInputViews()
}
else {
    // text keyboard
    self.textView.inputView = nil
    self.textView.reloadInputViews()
}
```

**If you want paste\copy\cut for emotion, u need to override these methods**
``` swift
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
```

You could deep into the example to see all the usages.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

wakary, redoume@163.com

## License

MYPEmotionKeyboard is available under the MIT license. See the LICENSE file for more info.
