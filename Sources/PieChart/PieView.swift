//
//  PieView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieView: UIView {
    private let configure: PieViewConfigure
    
    private var sectorView: PieSectorView?
    private var textView: DisplayLabel?
    
    private var notificationToken: NSObjectProtocol?
    
    init(configure: PieViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertSectorView()
        insertTextView()
        
        updateSectorViewStaticConstraints()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PieViewConfigure.emptyConfigure
        super.init(coder: coder)
        insertSectorView()
        insertTextView()
        
        updateSectorViewStaticConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateSectorViewDynamicConstraints()
    }
    
    deinit {
        guard let token = self.notificationToken else {
            return
        }
        NotificationCenter.default.removeObserver(token)
    }
    
    private func insertSectorView() {
        let sectorView = PieSectorView(configure: self.configure.pieSectorViewConfigure)
        self.sectorView = sectorView
        self.addSubview(sectorView)
        self.notificationToken = NotificationCenter.default.addObserver(forName: .didComputeLabelLocation, object: self.sectorView, queue: nil){
            [weak self] notification in
            guard let strongSelf = self else {
                return
            }
            guard let info = notification.userInfo, let lineEndPoint = info[sectorView.notificationInfoKey] as? CGPoint else {
                return
            }
            strongSelf.updateTextViewDynamicConstraints(for: lineEndPoint)
        }
    }
    
    private func insertTextView() {
        guard self.configure.isShowLabel else {
            return
        }
        let displayTextView = DisplayLabel(configure: self.configure.displayTextConfigure)
        self.addSubview(displayTextView)
        self.textView = displayTextView
    }
    
    private var labelWidth: CGFloat {
        var labelLength = self.bounds.width / 10
        labelLength = min(labelLength, 50)
        return labelLength
    }
    
    private var labelHeight: CGFloat {
        var labelHeight = min(self.bounds.width - 2 * labelWidth, self.bounds.height) / 16
        labelHeight = min(labelHeight, 20)
        return labelHeight
    }
    
    private func updateSectorViewStaticConstraints() {
        guard let sectorView = self.sectorView else {
            return
        }
        sectorView.snp.remakeConstraints{
            make in
            make.center.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalToSuperview()
        }
    }
    
    private func updateSectorViewDynamicConstraints() {
        guard let sectorView = self.sectorView else {
            return
        }
        sectorView.snp.updateConstraints{
            make in
            if self.configure.isShowLabel {
                make.width.equalTo(self.bounds.width - 2 * self.labelWidth)
            } else {
                make.width.equalToSuperview()
            }
        }
    }
    
    private func updateTextViewDynamicConstraints(for endPoint: CGPoint) {
        guard let textView = self.textView else {
            return
        }
        guard let sectorView = self.sectorView else {
            return
        }
        
        let newPoint = sectorView.convert(endPoint, to: self)
        let labelLength = self.labelWidth
        let labelHeight = self.labelHeight
        let centerY = newPoint.y
        let centerX: CGFloat
        if self.configure.isLeftSector {
            centerX = newPoint.x - labelLength / 2
        } else {
            centerX = newPoint.x + labelLength / 2
        }
        let center = CGPoint(x: centerX, y: centerY)
        textView.snp.updateConstraints{
            make in
            make.center.equalTo(center)
            make.height.equalTo(labelHeight)
            make.width.equalTo(labelLength)
        }
        textView.layoutIfNeeded()
        textView.setNeedsDisplay()
    }
}
