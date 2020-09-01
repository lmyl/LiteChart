//
//  DisplayLabelSyncCenter.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/8/31.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class DisplayLabelSyncCenter {
    
    private init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification(for:)), name: .updateLabelFont, object: nil)
        
    }
    
    private var sources: [DisplayLabelSyncIdentifier : [(WeakObjectPackage<DisplayLabel>, UIFont)]] = [:]
    
    private var minFonts: [DisplayLabelSyncIdentifier: UIFont] = [:]
    
    private let rwSourcesQueue = DispatchQueue(label: "library.rwSources.liteChart")
    private let processNotificationQueue = DispatchQueue(label: "library.processNotification.liteChart", attributes: .concurrent)
    
    static let shared = DisplayLabelSyncCenter()
    
    @objc private func processNotification(for notication: Notification) {
        guard let object = notication.object, let label = object as? DisplayLabel, let userInfo = notication.userInfo, let font = userInfo[DisplayLabel.notificationInfoFontKey] as? UIFont, let identifier = userInfo[DisplayLabel.notificationInfoSyncIdentitiferKey] as? DisplayLabelSyncIdentifier, identifier != .none else {
            return
        }
        rwSourcesQueue.async {
            let weakObject = WeakObjectPackage(value: label)
            let newCouple = (weakObject, font)
            if let weakObjects = self.sources[identifier] {
                var indexResult: Int?
                var tempObjects = weakObjects
                var deleteCount = 0
                for (index, temp) in weakObjects.enumerated() {
                    if let value = temp.0.value {
                        if value === label {
                            indexResult = index
                            break
                        }
                    } else {
                        deleteCount += 1
                        tempObjects.remove(at: index)
                    }
                }
                if let index = indexResult {
                    tempObjects[index - deleteCount] = newCouple
                    self.sources[identifier] = tempObjects
                    guard let minFont = self.minFonts[identifier] else {
                        fatalError("框架内部错误，不给予拯救!")
                    }
                    if minFont.pointSize >= font.pointSize {
                        self.minFonts[identifier] = font
                    } else {
                        tempObjects = tempObjects.filter({
                            $0.0.value != nil
                        })
                        self.sources[identifier] = tempObjects
                        guard let minFont = tempObjects.min(by: {
                            $0.1.pointSize < $1.1.pointSize
                        }) else {
                            fatalError("框架内部错误，不给予拯救!")
                        }
                        self.minFonts[identifier] = minFont.1
                    }
                } else {
                    self.sources[identifier] = tempObjects + [newCouple]
                    guard let minFont = self.minFonts[identifier] else {
                        fatalError("框架内部错误，不给予拯救!")
                    }
                    if minFont.pointSize > font.pointSize {
                        self.minFonts[identifier] = font
                    }
                }
                guard let minFont = self.minFonts[identifier] else {
                    return
                }
                NotificationCenter.default.post(name: identifier.identifier, object: nil, userInfo: [DisplayLabel.notificationInfoFontKey: minFont])
            } else {
                self.sources[identifier] = [newCouple]
                self.minFonts[identifier] = font
            }
            
        }
    }
    
}
