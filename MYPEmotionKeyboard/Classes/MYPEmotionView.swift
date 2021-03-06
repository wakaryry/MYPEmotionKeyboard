//
//  MYPEmotionView.swift
//  MYPEmotionKeyboard
//
//  Created by wakary redou on 2018/5/20.
//

import Foundation

public class MYPEmotionView: UIView {
    
    @IBOutlet weak var emotionCollection: MYPEmotionCollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var emotionMenuCollection: UICollectionView!
    public weak var delegate: MYPEmotionInputDelegate?
    
    /** user could set outside emotions*/
    public var emotionSets = [MYPEmotionSet]() {
        didSet {
            // reset emotionSetsUsed
            for s in self.emotionSets {
                self.emotionSetsAll.append(s)
            }
            self.emotionMenuCollection.reloadData()
        }
    }
    
    /** when we change emotionSet, we must change the isSmallItem. This will update the emotion view*/
    fileprivate var isSmallItem = true {
        didSet {
            if self.isSmallItem == oldValue {
                return
            }
            let number = self.isSmallItem ? MYPEmotionSmallNumber : MYPEmotionBigNumber
            let height = self.isSmallItem ? MYPEmotionSmallHeight : MYPEmotionBigHeight
            
            // calculate width and height
            let itemWidth = (UIScreen.main.bounds.width - 10 * 2) / number
            let padding = (UIScreen.main.bounds.width - number * itemWidth) / 2.0
            let paddingLeft = padding
            let paddingRight = UIScreen.main.bounds.width - paddingLeft - itemWidth * number
            
            // init FlowLayout
            let layout = self.emotionCollection.collectionViewLayout as! UICollectionViewFlowLayout  //UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: itemWidth, height: height)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
            
            // init emotion collection view
            // it will throw: `Thread 1: EXC_BAD_ACCESS`
            //self.emotionCollection.collectionViewLayout = layout
            
            self.emotionCollection.reloadData()
            
            let numbers = self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber
            
            var page = self.emotions.count / numbers
            page = (self.emotions.count - page * numbers) >= 1 ? (page + 1) : page
            self.pageControl.numberOfPages = page
            
            // we could position the collection scroll's offset
            self.emotionCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
            self.pageControl.currentPage = 0
        }
    }
    
    fileprivate var currentSetIndex: Int = 0 {
        didSet {
            self.emotions = self.emotionSetsAll[self.currentSetIndex].emotions
            self.isSmallItem = self.emotionSetsAll[self.currentSetIndex].isSmallType
        }
    }
    
    /** all the emotionSets including outside configured*/
    fileprivate var emotionSetsAll = [MYPEmotionSet.defaultEmotionSet()]
    fileprivate var emotions = MYPEmotion.defaultEmotions()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        custom()
    }
    
    private func custom() {
        
    }
    
    public override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        
        self.emotionCollection.delegate = self
        self.emotionCollection.dataSource = self
        
        self.emotionMenuCollection.delegate = self
        self.emotionMenuCollection.dataSource = self
        
        // calculate width and height
        // default small item
        let itemWidth = (UIScreen.main.bounds.width - 10 * 2) / MYPEmotionSmallNumber
        let padding = (UIScreen.main.bounds.width - MYPEmotionSmallNumber * itemWidth) / 2.0
        let paddingLeft = padding
        let paddingRight = UIScreen.main.bounds.width - paddingLeft - itemWidth * MYPEmotionSmallNumber
        
        // init FlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: MYPEmotionSmallHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
        
        // init emotion collection view
        self.emotionCollection.collectionViewLayout = layout
        self.emotionCollection.register(UINib(nibName: "MYPEmotionCell", bundle: MYPEmotionBundle), forCellWithReuseIdentifier: "MYPEmotionCellId")
        self.emotionCollection.isPagingEnabled = true
        
        self.emotionCollection.reloadData()
        
        var page = self.emotions.count / MYPEmotionSmallGroupNumber
        page = (self.emotions.count - page * MYPEmotionSmallGroupNumber) >= 1 ? (page + 1) : page
        self.pageControl.numberOfPages = page
        
        // init menu collection view
        let lay = UICollectionViewFlowLayout()
        lay.scrollDirection = .horizontal
        lay.itemSize = CGSize(width: MYPEmotionMenuWidth, height: MYPEmotionMenuHeight)
        lay.minimumLineSpacing = 0
        lay.minimumInteritemSpacing = 0
        lay.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight)
        self.emotionMenuCollection.collectionViewLayout = lay
        self.emotionMenuCollection.allowsMultipleSelection = false
        self.emotionMenuCollection.register(UINib(nibName: "MYPEmotionCell", bundle: MYPEmotionBundle), forCellWithReuseIdentifier: "MYPEmotionCellMenuId")
        
        self.emotionMenuCollection.reloadData()
        
        //self.emotionMenuCollection.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.left)
        //self.emotionMenuCollection.cellForItem(at: IndexPath(item: 0, section: 0))?.isSelected = true
        //self.collectionView(self.emotionMenuCollection, didSelectItemAt: IndexPath(item: 0, section: 0))
        
        self.emotionCollection.emotionCollectionDelegate = self
    }
}

extension MYPEmotionView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.emotionCollection {
            let h = self.emotions.count % (isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber)
            if h == 0 {
                return self.emotions.count / (isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber)
            }
            return self.emotions.count / (isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber) + 1
        }
        else {
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.emotionCollection {
            return isSmallItem ? (MYPEmotionSmallGroupNumber + 1) : MYPEmotionBigGroupNumber
        }
        else {
            return self.emotionSetsAll.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.emotionCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MYPEmotionCellId", for: indexPath) as! MYPEmotionCell
            // set selected style
            let v = UIView(frame: cell.frame)
            v.layer.cornerRadius = 5
            cell.selectedBackgroundView = v
            cell.selectedBackgroundView?.backgroundColor = UIColor.lightGray
            
            cell.isSmallType = self.isSmallItem
            
            if self.isSmallItem {
                if indexPath.row == MYPEmotionSmallGroupNumber {
                    cell.setDeleteCellContnet()
                }
                else {
                    cell.setCellContnet(self.emotionForIndexPath(indexPath))
                }
            }
            else {
                cell.setCellContnet(self.emotionForIndexPath(indexPath))
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MYPEmotionCellMenuId", for: indexPath) as! MYPEmotionCell
        // we must set smallType before setMenuContent.
        cell.isSmallType = self.emotionSetsAll[indexPath.row].isSmallType
        cell.setMenuContent(self.emotionSetsAll[indexPath.row].coverName)
        // set selected style
        let v = UIView(frame: cell.frame)
        v.layer.cornerRadius = 5
        cell.selectedBackgroundView = v
        cell.selectedBackgroundView?.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.emotionMenuCollection {
            if self.currentSetIndex == indexPath.row {
                return
            }
            self.currentSetIndex = indexPath.row
        }
        else if collectionView == self.emotionCollection {
            // delegate for action
            UIDevice.current.playInputClick()
            
            if self.isSmallItem {
                if indexPath.row == MYPEmotionSmallGroupNumber {
                    self.delegate?.emotionViewdidClickDelete(self)
                }
                else {
                    self.delegate?.emotionView(self, didClickEmotion: self.emotionForIndexPath(indexPath)!, isDefault: self.isSmallItem)
                }
            }
            else {
                self.delegate?.emotionView(self, didClickEmotion: self.emotionForIndexPath(indexPath)!, isDefault: self.isSmallItem)
            }
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    fileprivate func emotionForIndexPath(_ indexPath: IndexPath) -> MYPEmotion? {
        let page = indexPath.section
        var index = page * (self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber) + indexPath.row
        
        // new page
        let ip = index / (self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber)
        // new index
        let ii = index % (self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber)
        // index in data
        let reIndex = (ii % Int(self.isSmallItem ? MYPEmotionSmallLineNumber : MYPEmotionBigLineNumber)) * Int(self.isSmallItem ? MYPEmotionSmallNumber : MYPEmotionBigNumber) + (ii / 3)
        
        index = reIndex + ip * (self.isSmallItem ? MYPEmotionSmallGroupNumber : MYPEmotionBigGroupNumber)
        
        if index < self.emotions.count {
            return self.emotions[index]
        }
        
        return nil
    }
}

extension MYPEmotionView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.emotionCollection.frame.width
        self.pageControl.currentPage = Int(self.emotionCollection.contentOffset.x / pageWidth)
    }
}

extension MYPEmotionView: UIInputViewAudioFeedback {
    public var enableInputClicksWhenVisible: Bool {
        return true
    }
}

extension MYPEmotionView: MYPEmotionCollectionDelegate {
    func emotionCollectionViewDidClickDelete() {
        UIDevice.current.playInputClick()
        self.delegate?.emotionViewdidClickDelete(self)
    }
}
