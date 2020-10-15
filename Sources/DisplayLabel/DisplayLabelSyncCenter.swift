//
//  DisplayLabelSyncCenter.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/8/31.
//  Copyright © 2020 刘洋. All rights reserved.
//

import UIKit

class DisplayLabelSyncCenter {
    
    private var token: NSObjectProtocol?
    
    private var sources: [DisplayLabelSyncIdentifier : [(WeakObjectPackage<DisplayLabel>, UIFont)]] = [:]
    
    private var minFonts: [DisplayLabelSyncIdentifier: UIFont] = [:]
    private var syncQueue: [DisplayLabelSyncIdentifier: OperationQueue] = [:]
    
    private let rwSourcesQueue = DispatchQueue(label: "library.rwSources.syncCenter.liteChart", attributes: .concurrent)
    private let rwMinFonts = DispatchQueue(label: "library.rwMinFonts.syncCenter.liteChart", attributes: .concurrent)
    private let rwSyncQueueSignal = DispatchSemaphore(value: 1)
    
    private let processNotificationQueue = OperationQueue()
    
    static let shared = DisplayLabelSyncCenter()
    
    private init() {
        self.token = NotificationCenter.default.addObserver(forName: .updateLabelFont, object: nil, queue: processNotificationQueue, using: {
            [weak self] notification in
            self?.processNotification(for: notification)
        })
    }
    
    deinit {
        guard let token = token else {
            return
        }
        NotificationCenter.default.removeObserver(token)
    }
    
    private func readSources(for key: DisplayLabelSyncIdentifier) -> [(WeakObjectPackage<DisplayLabel>, UIFont)]? {
        var result: [(WeakObjectPackage<DisplayLabel>, UIFont)]? = nil
        rwSourcesQueue.sync {
            result = self.sources[key]
        }
        return result
    }
    
    private func writeSources(value: [(WeakObjectPackage<DisplayLabel>, UIFont)]?, for key: DisplayLabelSyncIdentifier) {
        rwSourcesQueue.async(flags: .barrier){
            self.sources[key] = value
        }
    }
    
    private func readMinFonts(for key: DisplayLabelSyncIdentifier) -> UIFont? {
        var result: UIFont? = nil
        rwMinFonts.sync {
            result = self.minFonts[key]
        }
        return result
    }
    
    private func writeMinFonts(value: UIFont?, for key: DisplayLabelSyncIdentifier) {
        rwMinFonts.async(flags: .barrier){
            self.minFonts[key] = value
        }
    }
    
    private func readSyncQueue(for key: DisplayLabelSyncIdentifier) -> OperationQueue {
        self.rwSyncQueueSignal.wait()
        defer {
            self.rwSyncQueueSignal.signal()
        }
        let result = self.syncQueue[key]
        if let queue = result {
            return queue
        } else {
            let new = OperationQueue()
            new.maxConcurrentOperationCount = 1
            self.syncQueue[key] = new
            return new
        }
    }
        
    private func processNotification(for notication: Notification) {
        guard let object = notication.object, let label = object as? DisplayLabel, let userInfo = notication.userInfo, let font = userInfo[DisplayLabel.notificationInfoFontKey] as? UIFont, let identifier = userInfo[DisplayLabel.notificationInfoSyncIdentitiferKey] as? DisplayLabelSyncIdentifier, identifier != .none else {
            return
        }
        let processQueue = readSyncQueue(for: identifier)
        let processBlock = BlockOperation{
            let weakObject = WeakObjectPackage(value: label)
            let newCouple = (weakObject, font)
            if let weakObjects = self.readSources(for: identifier) {
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
                    guard let minFont = self.readMinFonts(for: identifier) else {
                        fatalError("此为框架内部严重错误，不给予拯救")
                    }
                    if minFont.pointSize >= font.pointSize {
                        self.writeMinFonts(value: font, for: identifier)
                        self.writeSources(value: tempObjects, for: identifier)
                        NotificationCenter.default.post(name: identifier.identifier, object: nil, userInfo: [DisplayLabel.notificationInfoFontKey: font])
                    } else {
                        tempObjects = tempObjects.filter({
                            $0.0.value != nil
                        })
                        guard let minFont = tempObjects.min(by: {
                            $0.1.pointSize < $1.1.pointSize
                        }) else {
                            self.writeMinFonts(value: nil, for: identifier)
                            self.writeSources(value: nil, for: identifier)
                            return
                        }
                        self.writeMinFonts(value: minFont.1, for: identifier)
                        self.writeSources(value: tempObjects, for: identifier)
                        NotificationCenter.default.post(name: identifier.identifier, object: nil, userInfo: [DisplayLabel.notificationInfoFontKey: minFont.1])
                    }
                } else {
                    self.writeSources(value: tempObjects + [newCouple], for: identifier)
                    guard var minFont = self.readMinFonts(for: identifier) else {
                        fatalError("此为框架内部严重错误，不给予拯救")
                    }
                    if minFont.pointSize > font.pointSize {
                        minFont = font
                        self.writeMinFonts(value: font, for:identifier)
                    }
                    NotificationCenter.default.post(name: identifier.identifier, object: nil, userInfo: [DisplayLabel.notificationInfoFontKey: minFont])
                }
            } else {
                self.writeSources(value: [newCouple], for: identifier)
                self.writeMinFonts(value: font, for: identifier)
            }
        }
        processQueue.addOperation(processBlock)
    }
}
