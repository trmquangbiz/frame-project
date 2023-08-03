//
//  InfiniteScrollView.swift
//  InfiniteScrolling
//
//  Created by Quang Trinh on 12/30/19.
//  Copyright © 2019 Quang Trinh. All rights reserved.
//

import UIKit

protocol InfiniteScrollViewDelegate: AnyObject {
    func infiniteScrollViewDidScrollTo(_ scrollView: InfiniteScrollView, viewIndex: Int, valueIndex: Int)
    func infiniteScrollViewDidTap(_ scrollView: InfiniteScrollView, tileView: TileView, data: Any)
}
class InfiniteScrollView: UIScrollView {
    var dataSource: [Any] = []
    static let tilePadding: CGFloat = 15
    static let tileWidth = UIScreen.main.bounds.size.width - (tilePadding * 4)
    private var queue: DispatchQueue!
    private var didAutoScrollFirstTimes: Bool = false
    weak var paddingLeftTileView: TileView? {
        get {
            if viewMap.count > 0 {
                return viewMap[0]
            }
            return nil
        }
    }
    weak var infiniteScrollViewDelegate: InfiniteScrollViewDelegate?
    weak var paddingRightTileView: TileView? {
        get {
            let viewMapCount = viewMap.count
            if viewMapCount > 0 {
                return viewMap[viewMapCount - 1]
            }
            return nil
        }
    }
    
    private var autoScrollSession: Date?
    
    var viewMap: [TileView] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scrollsToTop = false
        self.frame = frame
        contentSize = frame.size
        contentInset = UIEdgeInsets.init(top: 0, left: InfiniteScrollView.tilePadding*2, bottom: 0, right: InfiniteScrollView.tilePadding*2)
        contentSize.width = InfiniteScrollView.tilePadding * 4 + 5 * InfiniteScrollView.tileWidth
        contentOffset.x = -30
        bounces = false
        queue = DispatchQueue.init(label: "loship.user.infinitescrollviewqueue")
        delegate = self
        decelerationRate = .fast
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = false
        alwaysBounceVertical = false
    }
    
    convenience init(frame: CGRect, queueSuffix: String) {
        self.init(frame: frame)
        queue = DispatchQueue.init(label: "loship.user.infinitescrollviewqueue.\(queueSuffix)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupRender(with index: Int) {
        resetSubviews()
        delegate = nil
        contentOffset.x = -(InfiniteScrollView.tilePadding*2)
        let view = TileView.init(frame: CGRect.init(x: 0, y: 0, width: InfiniteScrollView.tileWidth, height: frame.height))
        view.delegate = self
        view.updateData(dataSource[index])
        view.valueIndex = index
        addSubview(view)
        viewMap.append(view)
        delegate = self
        checkToRenderBothSide(isSetup: true)
        if let delegate = infiniteScrollViewDelegate {
            delegate.infiniteScrollViewDidScrollTo(self, viewIndex: 0, valueIndex: view.valueIndex)
        }
        if didAutoScrollFirstTimes == false {
            didAutoScrollFirstTimes = true
            startAutoScroll()
        }
        
    
    }
    
    func resetSubviews() {
        for view in viewMap {
            view.removeFromSuperview()
        }
        viewMap.removeAll()
    }
    func viewIsInOffset(_ view: TileView) -> Bool {
        let viewX = view.frame.origin.x
        let scrollViewX = contentOffset.x
        
        if (scrollViewX <= view.maxWidthX && viewX < scrollViewX) ||
            (viewX >= scrollViewX && viewX <= scrollViewX + UIScreen.main.bounds.size.width){
            return true
        }
        return false
    }
    
    func tileViewNeedRenderPreviousView(_ view: TileView) -> Bool{
        if view.previousView != nil {
            return false
        }
        if viewIsInOffset(view) {
            return true
        }
        return false
    }
    func tileViewNeedRenderNextView(_ view: TileView) -> Bool {
        if view.nextView != nil {
            return false
        }
        if viewIsInOffset(view) {
            return true
        }
        return false
    }
    
    func renderPrevious(for view: TileView, isSetup: Bool) {
        let valueIndex: Int = view.valueIndex
        var shiftX: CGFloat = 0
        let neededIndex = (valueIndex != 0) ? (valueIndex - 1) : (dataSource.count - 1)
        if neededIndex >= 0 && neededIndex < dataSource.count {
            if isSetup == false, let finalView = paddingRightTileView, viewIsInOffset(finalView) == false {
                // shift previous here
                let finalViewPreviousView = finalView.previousView
                if let finalViewPreviousView = finalViewPreviousView {
                    finalViewPreviousView.nextView = nil
                }
                finalView.updateData(dataSource[neededIndex])
                finalView.valueIndex = neededIndex
                // set
                let oldX = view.frame.origin.x
                finalView.previousView = nil
                view.setPreviousView(finalView)
                let newX = view.frame.origin.x
                shiftX = newX - oldX
                let finalView = viewMap.removeLast()
                if viewMap.count > 0 {
                    viewMap.insert(finalView, at: 0)
                }
                else {
                    viewMap.append(finalView)
                }
                if let view = finalViewPreviousView {
                    view.nextView = nil
                }
            }
            else {
                // create Tile view
                let previousView = TileView.init(frame: CGRect.init(x: 0, y: 0, width: InfiniteScrollView.tileWidth, height: frame.height))
                previousView.delegate = self
                previousView.updateData(dataSource[neededIndex])
                previousView.valueIndex = neededIndex
                // set
                let oldX = view.frame.origin.x
                view.setPreviousView(previousView)
                let newX = view.frame.origin.x
                shiftX = newX - oldX
                addSubview(previousView)
                if viewMap.count > 0 {
                    viewMap.insert(previousView, at: 0)
                }
                else {
                    viewMap.append(previousView)
                }
                
            }
        }
        
        contentOffset.x += shiftX
    }
    
    func renderNext(for view: TileView, isSetup: Bool) {
        let valueIndex: Int = view.valueIndex
        var shiftX: CGFloat = 0
        let neededIndex = (valueIndex != (dataSource.count - 1)) ? (valueIndex + 1) : 0
        if neededIndex >= 0 && neededIndex < dataSource.count {
            if isSetup == false, let firstView = paddingLeftTileView, viewIsInOffset(firstView) == false {
                // shift next here
                let firstViewNextView = firstView.nextView
                if let firstViewNextView = firstViewNextView {
                    firstViewNextView.previousView = nil
                }
                firstView.updateData(dataSource[neededIndex])
                firstView.valueIndex = neededIndex
                firstView.nextView = nil
                // set
                let oldX = view.frame.origin.x
                view.setNextView(firstView, isSetup: isSetup)
                let newX = view.frame.origin.x
                shiftX = newX - oldX
                let firstView = viewMap.removeFirst()
                viewMap.append(firstView)
                
                if let view = firstViewNextView {
                    view.previousView = nil
                }
            }
            else {
                // create Tile view
                let nextView = TileView.init(frame: CGRect.init(x: 0, y: 0, width: InfiniteScrollView.tileWidth, height: frame.height))
                nextView.delegate = self
                nextView.updateData(dataSource[neededIndex])
                nextView.valueIndex = neededIndex
                // set
                let oldX = view.frame.origin.x
                view.setNextView(nextView, isSetup: isSetup)
                let newX = view.frame.origin.x
                shiftX = newX - oldX
                addSubview(nextView)
                viewMap.append(nextView)
            }
        }
        
        contentOffset.x += shiftX
    }
    
    
    
    func checkToRenderBothSide(isSetup: Bool = false) {
        loopRenderPreviousView(isSetup)
        loopRenderNextView(isSetup)
    }
    
    func loopRenderPreviousView(_ isSetup: Bool) {
        if let tileView = paddingLeftTileView {
            checkToRenderPreviousTileView(tileView, isSetup: isSetup)
        }
    }
    
    func loopRenderNextView(_ isSetup: Bool) {
        if let tileView = paddingRightTileView {
            checkToRenderNextTileView(tileView, isSetup: isSetup)
        }
    }
    
    func checkToRenderPreviousTileView(_ tileView: TileView, isSetup: Bool) {
        if tileViewNeedRenderPreviousView(tileView) {
            renderPrevious(for: tileView, isSetup: isSetup)
            loopRenderPreviousView(isSetup)
        }
    }
    
    func checkToRenderNextTileView(_ tileView: TileView, isSetup: Bool) {
        if tileViewNeedRenderNextView(tileView) {
            renderNext(for: tileView, isSetup: isSetup)
            loopRenderNextView(isSetup)
        }
    }
    


    func startAutoScroll() {
        self.autoScrollSession = Date()
        autoScroll(withTimeSession: self.autoScrollSession!)
    }
    
    func autoScroll(withTimeSession session: Date) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {[weak self] in
            if let weakSelf = self, let currentSession = weakSelf.autoScrollSession, currentSession == session {
                if let viewIndex = weakSelf.getLargestIndexAreaInScreen() {
                    if viewIndex == weakSelf.viewMap.count - 1 {
                        weakSelf.loopRenderNextView(false)
                        if let newViewIndex = weakSelf.getLargestIndexAreaInScreen(), newViewIndex < weakSelf.viewMap.count && newViewIndex >= 0 {
                            let view = weakSelf.viewMap[newViewIndex + 1]
                            var rect = view.frame
                            rect.size.width = UIScreen.main.bounds.width
                            rect.origin.x -= 30
                            UIView.animate(withDuration: 0.2) {[weak self] in
                                if let weakSelf = self {
                                    weakSelf.contentOffset = rect.origin
                                }
                            }
                            if let delegate = weakSelf.infiniteScrollViewDelegate {
                                delegate.infiniteScrollViewDidScrollTo(weakSelf, viewIndex: newViewIndex + 1, valueIndex: view.valueIndex)
                            }
                        }
                        
                    }
                    else {
                        if viewIndex < weakSelf.viewMap.count {
                            let view = weakSelf.viewMap[viewIndex + 1]
                            var rect = view.frame
                            rect.size.width = UIScreen.main.bounds.width
                            rect.origin.x -= 30
                            UIView.animate(withDuration: 0.2) {[weak self] in
                                if let weakSelf = self {
                                    weakSelf.contentOffset = rect.origin
                                }
                            }
                            if let delegate = weakSelf.infiniteScrollViewDelegate {
                                delegate.infiniteScrollViewDidScrollTo(weakSelf, viewIndex: viewIndex + 1, valueIndex: view.valueIndex)
                            }
                            
                        }
                    }
                }
                weakSelf.autoScroll(withTimeSession: session)
            }
        }
    }
    
    
}

extension InfiniteScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        if contentOffsetX == -(scrollView.contentInset.left) {
            loopRenderPreviousView(false)
        }
        if contentOffsetX == (scrollView.contentSize.width - InfiniteScrollView.tileWidth - scrollView.contentInset.right) {
            loopRenderNextView(false)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        autoScrollSession = nil
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = scrollView.contentOffset
        scrollView.contentOffset = offset
        let translationX = scrollView.panGestureRecognizer.translation(in: superview).x
        
        let velocityX = scrollView.panGestureRecognizer.velocity(in: superview).x
        let halfTranslationMax = Double(InfiniteScrollView.tileWidth/2 + InfiniteScrollView.tilePadding) + 50
        let extraTranslation = Double(translationX).truncatingRemainder(dividingBy: Double(InfiniteScrollView.tileWidth))
        if let viewIndex = getLargestIndexAreaInScreen() {
            if velocityX < -600 {
                if viewIndex == viewMap.count - 1 {
                    loopRenderNextView(false)
                    if let newViewIndex = getLargestIndexAreaInScreen() {
                        if newViewIndex < viewMap.count {
                            if extraTranslation <=  -(halfTranslationMax){
                                let view = viewMap[newViewIndex]
                                var rect = view.frame
                                rect.size.width = UIScreen.main.bounds.width
                                rect.origin.x -= 30
                                targetContentOffset.pointee = rect.origin
                                if let delegate = infiniteScrollViewDelegate {
                                    delegate.infiniteScrollViewDidScrollTo(self, viewIndex: newViewIndex, valueIndex: view.valueIndex)
                                }
                            }
                            else {
                                if newViewIndex < viewMap.count && newViewIndex >= 0 {
                                    let view = viewMap[newViewIndex + 1]
                                    var rect = view.frame
                                    rect.size.width = UIScreen.main.bounds.width
                                    rect.origin.x -= 30
                                    targetContentOffset.pointee = rect.origin
                                    if let delegate = infiniteScrollViewDelegate {
                                        delegate.infiniteScrollViewDidScrollTo(self, viewIndex: newViewIndex + 1, valueIndex: view.valueIndex)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                else {
                    if viewIndex < viewMap.count {
                        if extraTranslation <=  -(halfTranslationMax){
                            let view = viewMap[viewIndex]
                            var rect = view.frame
                            rect.size.width = UIScreen.main.bounds.width
                            rect.origin.x -= 30
                            targetContentOffset.pointee = rect.origin
                            if let delegate = infiniteScrollViewDelegate {
                                delegate.infiniteScrollViewDidScrollTo(self, viewIndex: viewIndex, valueIndex: view.valueIndex)
                            }
                        }
                        else {
                            let view = viewMap[viewIndex + 1]
                            var rect = view.frame
                            rect.size.width = UIScreen.main.bounds.width
                            rect.origin.x -= 30
                            targetContentOffset.pointee = rect.origin
                            if let delegate = infiniteScrollViewDelegate {
                                delegate.infiniteScrollViewDidScrollTo(self, viewIndex: viewIndex + 1, valueIndex: view.valueIndex)
                            }
                        }
                        
                    }
                }
            }
            else if velocityX > 600 {
                if viewIndex == 0 {
                    loopRenderPreviousView(false)
                    
                    if let newViewIndex = getLargestIndexAreaInScreen(), newViewIndex > 0 {
                        if extraTranslation > halfTranslationMax {
                            let view = viewMap[newViewIndex]
                            var rect = view.frame
                            rect.size.width = UIScreen.main.bounds.width
                            rect.origin.x -= 30
                            targetContentOffset.pointee = rect.origin
                            if let delegate = infiniteScrollViewDelegate {
                                delegate.infiniteScrollViewDidScrollTo(self, viewIndex: newViewIndex, valueIndex: view.valueIndex)
                            }
                        }
                        else {
                            let view = viewMap[newViewIndex - 1]
                            var rect = view.frame
                            rect.size.width = UIScreen.main.bounds.width
                            rect.origin.x -= 30
                            targetContentOffset.pointee = rect.origin
                            if let delegate = infiniteScrollViewDelegate {
                                delegate.infiniteScrollViewDidScrollTo(self, viewIndex: newViewIndex - 1, valueIndex: view.valueIndex)
                            }
                        }
                        
                    }
                }
                else {
                    if extraTranslation > halfTranslationMax {
                        let view = viewMap[viewIndex]
                        var rect = view.frame
                        rect.size.width = UIScreen.main.bounds.width
                        rect.origin.x -= 30
                        targetContentOffset.pointee = rect.origin
                        if let delegate = infiniteScrollViewDelegate {
                            delegate.infiniteScrollViewDidScrollTo(self, viewIndex: viewIndex, valueIndex: view.valueIndex)
                        }
                    }
                    else {
                        let view = viewMap[viewIndex - 1]
                        var rect = view.frame
                        rect.size.width = UIScreen.main.bounds.width
                        rect.origin.x -= 30
                        targetContentOffset.pointee = rect.origin
                        if let delegate = infiniteScrollViewDelegate {
                            delegate.infiniteScrollViewDidScrollTo(self, viewIndex: viewIndex - 1, valueIndex: view.valueIndex)
                        }
                    }
                }
            }
            else if velocityX != 0, let viewIndex = getLargestIndexAreaInScreen(){
                if viewMap.count > viewIndex {
                    let view = viewMap[viewIndex]
                    var rect = view.frame
                    rect.size.width = UIScreen.main.bounds.width
                    rect.origin.x -= 30
                    targetContentOffset.pointee = rect.origin
                    if let delegate = infiniteScrollViewDelegate {
                        delegate.infiniteScrollViewDidScrollTo(self, viewIndex: viewIndex, valueIndex: view.valueIndex)
                    }
                }
            }
        }
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        scrollView.contentOffset = offset
        let velocityX = scrollView.panGestureRecognizer.velocity(in: superview).x
        if velocityX ==  0, let viewIndex = getLargestIndexAreaInScreen() {
            if viewMap.count > viewIndex {
                let view = viewMap[viewIndex]
                var rect = view.frame
                rect.size.width = UIScreen.main.bounds.width
                rect.origin.x -= 30
                scrollView.setContentOffset(rect.origin, animated: true)
                if let delegate = infiniteScrollViewDelegate {
                    delegate.infiniteScrollViewDidScrollTo(self, viewIndex: viewIndex, valueIndex: view.valueIndex)
                }
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = true
        startAutoScroll()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = true
        checkToRenderBothSide()
        startAutoScroll()
    }
    
    func getViewMapIndex() -> Int {
        let range = InfiniteScrollView.tileWidth + InfiniteScrollView.tilePadding
        let contentOffsetX = contentOffset.x
        let calculatedPart = Double(contentOffsetX/range)
        let part = floor(calculatedPart)
        if part <= 0 {
            return 0
        }
        return Int(part)
    }
    
    
    
    func getCurrentViewInRangeValueIndex() -> Int? {
        let index = getViewMapIndex()
        if index < viewMap.count && viewMap.count > 0 {
            return viewMap[index].valueIndex
        }
        return nil
    }
    
    func getLargestIndexAreaInScreen() -> Int? {
        if viewMap.count > 0 {
            let mainViewIndex = getViewMapIndex()
            var largestIndex: Int = mainViewIndex
            let nextIndex = largestIndex + 1
            let previousIndex = largestIndex - 1

            var bestArea: CGFloat = 0
            if mainViewIndex < viewMap.count {
                let mainView = viewMap[mainViewIndex]
                let area = getViewAreaInOffset(view: mainView)
                if area > bestArea {
                    bestArea = area
                    largestIndex = mainViewIndex
                }
                
            }
            if nextIndex < viewMap.count {
                let nextView = viewMap[nextIndex]
                let area = getViewAreaInOffset(view: nextView)
                if area > bestArea {
                    bestArea = area
                    largestIndex = nextIndex
                }
                
                
            }
            if previousIndex >= 0 {
                let previousView = viewMap[previousIndex]
                let area = getViewAreaInOffset(view: previousView)
                if area > bestArea {
                    bestArea = area
                    largestIndex = previousIndex
                }
                
            }
            return largestIndex
        }
        return nil
        
        
        
        
    }
    
    func getViewAreaInOffset(view: TileView) -> CGFloat{
        let contentOffsetX = contentOffset.x
        let contentOffsetMaxX = contentOffsetX + UIScreen.main.bounds.size.width
        let viewX = view.frame.origin.x
        let viewMaxX = view.maxWidthX
        if viewX <= contentOffsetX && viewMaxX >= contentOffsetX {
            return (viewMaxX - contentOffsetX)
        }
        else if viewX > contentOffsetX && viewX <= contentOffsetMaxX {
            if viewMaxX <= contentOffsetMaxX {
                return InfiniteScrollView.tileWidth
            }
            else {
                return contentOffsetMaxX - viewX
            }
        }
        else {
            return 0
        }
    }
    
}


extension InfiniteScrollView: TileViewDelegate {
    func tileViewDidTap(_ tileView: TileView, data: Any) {
        if let delegate = infiniteScrollViewDelegate {
            delegate.infiniteScrollViewDidTap(self, tileView: tileView, data: data)
        }
    }
    
    
}

protocol TileViewDelegate: AnyObject {
    func tileViewDidTap(_ tileView: TileView, data: Any)
}

class TileView: UIView {
    var maxWidthX: CGFloat {
        get {
            return frame.origin.x + frame.width
        }
    }
    let imageView = UIImageView()
    var valueIndex: Int!
    var data: Any! {
        didSet {
            didSetData()
        }
    }
    weak var delegate: TileViewDelegate?
    weak var nextView: TileView?
    weak var previousView: TileView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = frame
        imageView.frame.origin = CGPoint.zero
        imageView.contentMode = .scaleAspectFill
        imageView.addCornerRadius()
        imageView.layer.masksToBounds = true
        addSubview(imageView)
        backgroundColor = UIColor.clear
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap() {
        if let delegate = delegate, let data = data {
            delegate.tileViewDidTap(self, data: data)
        }
    }
    func updateData(_ data: Any) {
        self.data = data
        
    }
    func didSetData() {
        // TODO
    }
    
    func setPreviousView(_ view: TileView) {
        view.frame = frame
        previousView = view
        view.nextView = self
        if let view = nextView {
            view.setPreviousView(self)
        }
        else {
            frame.origin.x += (view.frame.width + InfiniteScrollView.tilePadding)
        }
    }
    
    func setNextView(_ view: TileView, isSetup: Bool) {
        if isSetup {
            view.frame = CGRect.init(x: maxWidthX + InfiniteScrollView.tilePadding, y: 0, width: view.frame.width, height: view.frame.height)
        }
        else {
            view.frame = frame
        }
        nextView = view
        view.previousView = self
        if let view = previousView {
            view.setNextView(self, isSetup: isSetup)
        }
        else if isSetup == false {
            frame.origin.x -= (view.frame.width + InfiniteScrollView.tilePadding)
        }
    }
    
    
    
}
