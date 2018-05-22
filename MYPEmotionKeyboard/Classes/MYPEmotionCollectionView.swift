//
//  MYPEmotionCollectionView.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/22.
//

import Foundation

public class MYPEmotionCollectionView: UICollectionView {
    fileprivate var deleteTimer: Timer!
    weak var emotionCollectionDelegate: MYPEmotionCollectionDelegate?
    var longPress: UILongPressGestureRecognizer!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        custom()
    }
    
    private func custom() {
        self.longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.addGestureRecognizer(self.longPress)
    }
    
    public override func awakeFromNib() {
        self.clipsToBounds = false
        self.showsHorizontalScrollIndicator = false
        self.isUserInteractionEnabled = true
        self.canCancelContentTouches = false
        self.isMultipleTouchEnabled = false
        self.scrollsToTop = false
    }
    
    func cellForTouches(_ touches: Set<UITouch>) -> MYPEmotionCell? {
        let touch =  touches.first as UITouch?
        let point = touch?.location(in: self)
        let indexPath = self.indexPathForItem(at: point!)
        guard let newIndexPath = indexPath else {
            return nil
        }
        let cell: MYPEmotionCell = self.cellForItem(at: newIndexPath) as! MYPEmotionCell
        return cell
    }
    
    /**
     stop timmer
     */
    func endDeleteTimer() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(MYPEmotionCollectionView.startDeleteTimer), object: nil)
        if self.deleteTimer != nil {
            self.deleteTimer.invalidate()
            self.deleteTimer = nil
        }
    }
    
    @objc func startDeleteTimer() {
        self.endDeleteTimer()
        
        self.deleteTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(delegateDeleteAction), userInfo: nil, repeats: true)
        RunLoop.main.add(self.deleteTimer, forMode: .commonModes)
    }
    
    @objc func delegateDeleteAction() {
        self.emotionCollectionDelegate?.emotionCollectionViewDidClickDelete()
    }
    
    deinit {
        self.endDeleteTimer()
    }
}

extension MYPEmotionCollectionView {
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self)
        let indexPath = self.indexPathForItem(at: location)
        
        guard let newIndexPath = indexPath else {
            return
        }
        let cell: MYPEmotionCell = self.cellForItem(at: newIndexPath) as! MYPEmotionCell
        
        if cell.isDelete {
            switch sender.state {
            case .began:
                self.endDeleteTimer()
                self.perform(#selector(startDeleteTimer), with: nil, afterDelay: 0.1)
                break
            case .possible:
                break
            case .changed:
                break
            case .ended:
                self.endDeleteTimer()
                break
            case .cancelled:
                self.endDeleteTimer()
                break
            case .failed:
                self.endDeleteTimer()
                break
            }
        }
        else {
            self.endDeleteTimer()
        }
    }
}

/* we use a long press to handle
extension MYPEmotionCollectionView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cell = self.cellForTouches(touches) else {
            return
        }
        
        if cell.isDelete {
            self.endDeleteTimer()
            
            self.perform(#selector(startDeleteTimer), with: nil, afterDelay: 0.1)
        }
        else {

            self.delegate?.collectionView!(self, didSelectItemAt: self.indexPath(for: cell)!)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cell = self.cellForTouches(touches) else {
            return
        }
        
        if !cell.isDelete {
            self.endDeleteTimer()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endDeleteTimer()
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endDeleteTimer()
    }
}
*/
