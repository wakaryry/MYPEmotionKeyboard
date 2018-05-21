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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var changeButton: UIButton!
    
    var emotionView: MYPEmotionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.emotionView = MYPEmotionKeyboardView
        self.emotionView?.delegate = self
        self.changeButton.tag = 0
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

extension ViewController: MYPEmotionInputDelegate {
    func emotionView(_ emotionView: MYPEmotionView, didClickEmotion emotion: MYPEmotion) {
        
    }
    
    func emotionViewdidClickDelete(_ emotionView: MYPEmotionView) {
        
    }
    
    
}

