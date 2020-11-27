//
//  LiteChartAnimationTimingFunction.swift
//  LiteChart
//
//  Created by 刘洋 on 2020/10/22.
//  Copyright © 2020 刘洋. All rights reserved.
//

import Foundation
import UIKit

///
public struct LiteChartAnimationTimingFunction {
    internal var timingFunction: CAMediaTimingFunction
    
    /// Timing function initialization using predefined system timing function names.
    /// - Parameter name: `CAMediaTimingFunctionName`, choose from `default`, `easeIn`, `easeOut`, `easeInOut` and `linear`
    public init(name: CAMediaTimingFunctionName) {
        self.timingFunction = .init(name: name)
    }
    
    /// Timing function initialization, returns an intialized timing function modeled as a cubic Bézier curve using the specified control points.
    /// - Parameters:
    ///   - firstControl: `CGPoint`in the range of (0, 0) ~ (1,1)
    ///   - secondControl: `CGPoint` in the range of (0, 0) ~ (1,1)
    public init(firstControl: CGPoint, secondControl: CGPoint) {
        var newFirst = firstControl
        if newFirst.x > 1 {
            newFirst.x = 1
        } else if newFirst.x < 0 {
            newFirst.x = 0
        }
        if newFirst.y > 1 {
            newFirst.y = 1
        } else if newFirst.y < 0 {
            newFirst.y = 0
        }
        
        var newSecond = secondControl
        if newSecond.x > 1 {
            newSecond.x = 1
        } else if newSecond.x < 0 {
            newSecond.x = 0
        }
        if newSecond.y > 1 {
            newSecond.y = 1
        } else if newSecond.y < 0 {
            newSecond.y = 0
        }
        
        self.timingFunction = .init(controlPoints: Float(newFirst.x), Float(newFirst.y), Float(newSecond.x), Float(newSecond.y))
    }
    
    private var controlPoints: [CGPoint] {
        var result: [CGPoint] = []
        for index in 0 ... 3 {
            let point = UnsafeMutablePointer<Float>.allocate(capacity: 2)
            self.timingFunction.getControlPoint(at: index, values: point)
            let x = point.pointee
            let y = (point + 1).pointee
            point.deinitialize(count: 2)
            point.deallocate()
            result.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
        }
        return result
    }
    
    internal func getTimeForSortedProgress(for progress: [CGFloat]) -> [CGFloat] {
        var beforTime: Double = 0
        var beforTimeValue: CGFloat = 0
        var result: [CGFloat] = []
        var nowProgressMatch = 0
        let strideTime = Array(stride(from: 0, through: 1, by: 0.01))
        var nowTimeMatch = 0
        while nowTimeMatch < strideTime.count && nowProgressMatch < progress.count {
            let compluteProgress = self.computeValueForParameter(to: CGFloat(strideTime[nowTimeMatch]), forX: false)
            if compluteProgress > progress[nowProgressMatch] {
                let diffBefore = progress[nowProgressMatch] - beforTimeValue
                let diffNow = compluteProgress - progress[nowProgressMatch]
                if diffBefore > diffNow {
                    let xValue = self.computeValueForParameter(to: CGFloat(strideTime[nowTimeMatch]), forX: true)
                    result.append(xValue)
                } else {
                    let xValue = self.computeValueForParameter(to: CGFloat(beforTime), forX: true)
                    result.append(xValue)
                }
                beforTime = strideTime[nowTimeMatch]
                beforTimeValue = compluteProgress
                nowProgressMatch += 1
            } else if compluteProgress == progress[nowProgressMatch] {
                let xValue = self.computeValueForParameter(to: CGFloat(strideTime[nowTimeMatch]), forX: true)
                result.append(xValue)
                beforTime = strideTime[nowTimeMatch]
                beforTimeValue = compluteProgress
                nowProgressMatch += 1
            } else {
                beforTime = strideTime[nowTimeMatch]
                beforTimeValue = compluteProgress
                nowTimeMatch += 1
            }
        }
        return result
    }
    
    private func computeValueForParameter(to time: CGFloat, forX: Bool) -> CGFloat {
        var newTime = time
        if newTime > 1 {
            newTime = 1
        } else if newTime < 0 {
            newTime = 0
        }
        let controlPoints = self.controlPoints
        let firstControl = controlPoints[0]
        let secondControl = controlPoints[1]
        let thirdControl = controlPoints[2]
        let fourthControl = controlPoints[3]
        if forX {
            let result = firstControl.x * pow(1 - time, 3) + 3 * secondControl.x * time * pow(1 - time, 2) + 3 * thirdControl.x * pow(time, 2) * (1 - time) + fourthControl.x * pow(time, 3)
            return result
        } else {
            let result = firstControl.y * pow(1 - time, 3) + 3 * secondControl.y * time * pow(1 - time, 2) + 3 * thirdControl.y * pow(time, 2) * (1 - time) + fourthControl.y * pow(time, 3)
            return result
        }
        
    }
}
