//
//  PieView.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/6/8.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class PieView: UIView {
    let configure: PieViewConfigure
    
    var sectorView: PieSectorView?
    var textView: DisplayLabel?
    
    var notificationToken: NSObjectProtocol?
    
    init(configure: PieViewConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        insertSectorView()
        insertTextView()
    }
    
    required init?(coder: NSCoder) {
        self.configure = PieViewConfigure()
        super.init(coder: coder)
        insertSectorView()
        insertTextView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSectorViewConstraints()
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
            strongSelf.updateTextViewConstraints(for: lineEndPoint)
        }
    }
    
    private func insertTextView() {
        guard let displayTextConfigure = self.configure.displayTextConfigure else {
            return
        }
        let displayTextView = DisplayLabel(configure: displayTextConfigure)
        self.addSubview(displayTextView)
        self.textView = displayTextView
    }
    
    private func updateSectorViewConstraints() {
        guard let sectorView = self.sectorView else {
            return
        }
        sectorView.snp.updateConstraints{
            make in
            make.center.equalToSuperview()
            if self.configure.isShowLabel {
                var labelLength = self.bounds.width / 10
                labelLength = min(labelLength, 50)
                make.width.equalTo(self.bounds.width - 2 * labelLength)
            } else {
                make.width.equalToSuperview()
            }
            make.height.equalToSuperview()
        }
    }
    
    private func updateTextViewConstraints(for endPoint: CGPoint) {
        guard let textView = self.textView else {
            return
        }
        guard let sectorView = self.sectorView else {
            return
        }
        
        let newPoint = sectorView.convert(endPoint, to: self)
        let labelLength = (self.bounds.width - sectorView.bounds.width) / 2
        var labelHeight = min(sectorView.bounds.width, sectorView.bounds.height) / 16
        labelHeight = min(labelHeight, 20)
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
    }
}
