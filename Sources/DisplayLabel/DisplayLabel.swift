//
//  DisplayLabel.swift
//  
//
//  Created by 刘洋 on 2020/6/5.
//

import UIKit

class DisplayLabel: UIView {
    
    static let notificationInfoFontKey = "font"
    static let notificationInfoSyncIdentitiferKey = "sync"
    
    private let configure: DisplayLabelConfigure
    private var suitFont = UIFont.systemFont(ofSize: 17)
    private var token: NSObjectProtocol?
    private var rwFontSignal = DispatchSemaphore(value: 1)
    private var processNotificationQueue = OperationQueue()
    
    private var font: UIFont {
        set {
            rwFontSignal.wait()
            guard suitFont.pointSize != newValue.pointSize else {
                rwFontSignal.signal()
                return
            }
            suitFont = newValue
            rwFontSignal.signal()
            layer.setNeedsDisplay()
        }
        get {
            rwFontSignal.wait()
            let result = suitFont
            rwFontSignal.signal()
            return result
        }
    }
        
    init(configure: DisplayLabelConfigure) {
        self.configure = configure
        super.init(frame: CGRect())
        
        guard self.configure.syncIdentifier != .none else {
            return
        }
        let token = NotificationCenter.default.addObserver(forName: self.configure.syncIdentifier.identifier, object: nil, queue: self.processNotificationQueue, using: {
            [weak self] notification in
            guard let `self` = self else {
                return
            }
            guard let info = notification.userInfo, let content = info[DisplayLabel.notificationInfoFontKey], let font = content as? UIFont else {
                return
            }
            
            DispatchQueue.main.async {
                if self.isSuitFontForSize(font: font, size: self.layer.bounds.size) {
                    self.font = font
                    self.layer.displayIfNeeded()
                }
            }
        })
        self.token = token
    }
    
    deinit {
        guard let token = self.token else {
            return
        }
        NotificationCenter.default.removeObserver(token)
    }
    
    required init?(coder: NSCoder) {
        self.configure = DisplayLabelConfigure.emptyConfigure
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let font = self.computeSuitableFont(for: layer.bounds.size).0
        self.font = font
        
        if self.configure.syncIdentifier != .none {
            NotificationCenter.default.post(name: .updateLabelFont, object: self, userInfo: [DisplayLabel.notificationInfoFontKey: font, DisplayLabel.notificationInfoSyncIdentitiferKey: self.configure.syncIdentifier])
        }
        
    }
    
    override func display(_ layer: CALayer) {
        LiteChartDispatchQueue.asyncDrawQueue.async {
            layer.contentsScale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, layer.contentsScale)
            let context = UIGraphicsGetCurrentContext()
            let rect = layer.bounds
            context?.saveGState()
            context?.clear(rect)
            var textSizeArea = rect.size
            if self.configure.textDirection == .vertical {
                context?.rotate(by: CGFloat(0 - Double.pi / 2))
                textSizeArea = CGSize(width: textSizeArea.height, height: textSizeArea.width)
            }
            
            let adjustFont = self.font
            let adjustSize = self.computeSizeFor(font: adjustFont)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.configure.textAlignment
            var textAttributs: [NSAttributedString.Key : Any] = [:]
            textAttributs[.font] = adjustFont
            textAttributs[.foregroundColor] = self.configure.contentColor.color
            textAttributs[.paragraphStyle] = paragraphStyle
            
            var stringRect: CGRect
            switch self.configure.textDirection {
            case .horizontal:
                stringRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.height - adjustSize.height) / 2, width: rect.width, height: adjustSize.height)
            case .vertical:
                let textSize = adjustSize
                stringRect = CGRect(x: 0 - rect.height, y: (rect.width - textSize.height) / 2, width: rect.height, height: textSize.height)
            }
            let nsString = self.configure.contentString as NSString
            nsString.draw(in: stringRect, withAttributes: textAttributs)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            context?.restoreGState()
            UIGraphicsEndImageContext()
            LiteChartDispatchQueue.asyncDrawDoneQueue.async {
                layer.contents = image?.cgImage
            }
            
        }
    }
}

extension DisplayLabel {
    private func computeSuitableFont(for size: CGSize) -> (UIFont, CGSize) {
        var newFont = UIFont.systemFont(ofSize: 17)
        var fontSize = newFont.pointSize
        let nsstring = self.configure.contentString as NSString
        var rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : newFont], context: nil)
        while rect.height > size.height || rect.width > size.width {
            if fontSize <= 0.5 {
                fontSize = 0.1
                rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : newFont], context: nil)
                return (UIFont.systemFont(ofSize: fontSize), rect.size)
            }
            fontSize -= 0.5
            newFont = UIFont.systemFont(ofSize: fontSize)
            rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : newFont], context: nil)
        }
        return (newFont, rect.size)
    }
    
    private func isSuitFontForSize(font: UIFont, size: CGSize) -> Bool {
        let nsstring = self.configure.contentString as NSString
        let rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        if rect.height > size.height || rect.width > size.width {
            return false
        } else {
            return true
        }
    }
    
    private func computeSizeFor(font: UIFont) -> CGSize {
        let nsstring = self.configure.contentString as NSString
        let rect = nsstring.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        return rect.size
    }
}

