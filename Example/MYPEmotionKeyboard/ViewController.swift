//
//  ViewController.swift
//  MYPEmotionKeyboard
//
//  Created by mayuping321@163.com on 05/19/2018.
//  Copyright (c) 2018 mayuping321@163.com. All rights reserved.
//

import UIKit
import MYPEmotionKeyboard

class ViewController: UIViewController {
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var changeButton: UIButton!
    
    var emotionView: MYPEmotionView?
    
    var font: UIFont?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.emotionView = MYPEmotionKeyboardView
        self.emotionView?.delegate = self
        self.changeButton.tag = 0
        self.textView.delegate = self
        self.textView.font = UIFont.systemFont(ofSize: 18)
        self.font = self.textView.font
        
        if #available(iOS 11.0, *) {
            self.textView.textDragInteraction?.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func change(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
        }
        else {
            sender.tag = 0
        }
        
        if self.textView.isFirstResponder {
            if sender.tag == 1 {
                self.textView.inputView = self.emotionView
                self.textView.reloadInputViews()
            }
            else {
                self.textView.inputView = nil
                self.textView.reloadInputViews()
            }
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.refreshTextUI()
        self.textView.scrollRangeToVisible(self.textView.selectedRange)
    }
    
    private func refreshTextUI() {
        if self.textView.text.isEmpty {
            // since the font may not correct when empty
            self.textView.font = self.font
            return
        }
        
        let markedTextRange = self.textView.markedTextRange
        
        if let m = markedTextRange {
            let position = self.textView.position(from: m.start, offset: 0)
            
            if position != nil {
                return
            }
        }
        
        let selectedRange = self.textView.selectedRange
        
        let attributedComment = NSMutableAttributedString(string: self.textView.attributedText.plainText(), attributes: [NSAttributedStringKey.font : self.font!, .foregroundColor: UIColor.black])
        
        attributedComment.translateAttributedTextIntoEmotionText(with: self.font)
        
        let offset = self.textView.attributedText.length - attributedComment.length
        self.textView.attributedText = attributedComment
        self.textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0)
    }
}

extension ViewController: MYPEmotionInputDelegate {
    
    func emotionView(_ emotionView: MYPEmotionView, didClickEmotion emotion: MYPEmotion, isDefault: Bool) {
        let selectedRange = self.textView.selectedRange
        let emotionString = emotion.description
        let emotionAttributedString = NSMutableAttributedString(string: emotionString)
        emotionAttributedString.myp_setTextBackedString(MYPTextBackedString(string: emotionString), range: emotionAttributedString.myp_rangeOfAll())
        
        let attributedText = NSMutableAttributedString(attributedString: self.textView.attributedText)
        
        attributedText.replaceCharacters(in: selectedRange, with: emotionAttributedString)
        
        self.textView.attributedText = attributedText
        self.textView.selectedRange = NSMakeRange(selectedRange.location + emotionAttributedString.length, 0)
        
        self.textViewDidChange(self.textView)
    }
    
    func emotionViewdidClickDelete(_ emotionView: MYPEmotionView) {
        let selectedRange = self.textView.selectedRange
        
        if selectedRange.location == 0 && selectedRange.length == 0 {
            return
        }
        
        let attributedText = NSMutableAttributedString(attributedString: self.textView.attributedText)
        
        if selectedRange.length > 0 {
            attributedText.deleteCharacters(in: selectedRange)
            self.textView.attributedText = attributedText
            self.textView.selectedRange = NSMakeRange(selectedRange.location, 0)
        }
        else {
            attributedText.deleteCharacters(in: NSMakeRange(selectedRange.location - 1, 1))
            self.textView.attributedText = attributedText
            self.textView.selectedRange = NSMakeRange(selectedRange.location - 1, 0)
        }
        
        self.textViewDidChange(self.textView)
    }
    
}

