//
//  HealthBarNode.swift
//  Habi
//
//  Created by Enzu Ao on 15/04/23.
//

import Foundation
import SpriteKit

class HealthBarNode: SKNode {
    private let backgroundNode: SKSpriteNode
    private let foregroundNode: SKSpriteNode
    private let cropNode: SKCropNode
    private let maskNode: SKSpriteNode
    private let labelTitle: SKLabelNode
    private let labelTimeLeft: TimerLabel
    private var labelHealthPercentage: SKLabelNode
    private var duration: TimeInterval
    private let decreaseAmount: CGFloat
    private var progress:CGFloat
    private var currentRoutineVM: CurrentRoutineViewModel
    
    var size: CGSize {
        didSet {
            backgroundNode.size = size
            foregroundNode.size = size
            maskNode.size = size
        }
    }
    
    init(size: CGSize, currentRoutineVM: CurrentRoutineViewModel) {
        self.size = size
        self.currentRoutineVM = currentRoutineVM
        backgroundNode = SKSpriteNode(color: .gray, size: size)
        foregroundNode = SKSpriteNode(color: .green, size: size)
        cropNode = SKCropNode()
        maskNode = SKSpriteNode(color: .white, size: size)
        labelTitle = SKLabelNode(text: currentRoutineVM.currentRoutine.title)
        labelHealthPercentage = SKLabelNode()
        labelTimeLeft = TimerLabel()
        self.duration = Double(currentRoutineVM.currentRoutine.durationHours * 3600 + currentRoutineVM.currentRoutine.durationMinutes * 60)
        self.decreaseAmount = 1.0/duration
        let tIntervalN = currentRoutineVM.currentRoutine.timeStart.timeIntervalSinceNow
        let currentTimeEnd = currentRoutineVM.currentRoutine.timeStart.addingTimeInterval(duration)
        let tIntervalS = currentTimeEnd.timeIntervalSince(currentRoutineVM.currentRoutine.timeStart)
        print(tIntervalN, tIntervalS)
        
        print(Double(tIntervalN/tIntervalS))
        self.progress = 1.0 + Double(tIntervalN/tIntervalS)
        
        super.init()
        addChild(backgroundNode)
        
        labelTitle.fontName = "SF Mono"
        labelTitle.fontSize = 20
        labelTitle.fontColor = .black
        labelTitle.position = CGPoint(x: 0, y: 22)
        labelTitle.horizontalAlignmentMode = .center
        
        labelTimeLeft.fontName = "SF Mono"
        labelTimeLeft.fontSize = 20
        labelTimeLeft.fontColor = .black
        labelTimeLeft.position = CGPoint(x: -backgroundNode.size.width/2 + 200, y: -35)
        labelTimeLeft.horizontalAlignmentMode = .right
        labelTimeLeft.startTime(duration: currentRoutineVM.currentRoutine.timeEnd.timeIntervalSince(currentRoutineVM.currentRoutine.timeStart), startTime: currentRoutineVM.currentRoutine.timeStart, endTime: currentRoutineVM.currentRoutine.timeEnd)
        
        labelHealthPercentage.fontName = "SF Mono"
        labelHealthPercentage.fontSize = 20
        labelHealthPercentage.fontColor = .black
        labelHealthPercentage.position = CGPoint(x: 0, y: -8)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        backgroundNode.addChild(labelTitle)
        backgroundNode.addChild(labelTimeLeft)
        cropNode.maskNode = maskNode
        cropNode.addChild(foregroundNode)
        addChild(cropNode)
        addChild(labelHealthPercentage)
        
        let decreaseAction = SKAction.customAction(withDuration: duration) {(node, elapsedTime) in
            guard let healthBar = node as? HealthBarNode else { return }
            
            
            let newProgress = max(0, healthBar.progress - (self.decreaseAmount * CGFloat(elapsedTime)))
            
            self.setProgress(newProgress)
            self.labelHealthPercentage.text = formatter.string(from: NSNumber(value: newProgress)) ?? ""
        }
        
        self.run(decreaseAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: CGFloat) {
        maskNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        maskNode.position.x = -size.width/2 + maskNode.size.width/2
        let clampedProgress = max(min(progress, 1.0), 0.0)
        maskNode.size.width = size.width * clampedProgress
    }
}

class TimerLabel: SKLabelNode {
    var startTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var endTime: Date = Date()
   
    
    func startTime(duration: TimeInterval, startTime: Date, endTime: Date) {
        self.duration = duration
        self.startTime = startTime.timeIntervalSinceReferenceDate
        self.endTime = endTime
        self.updateText()
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    func updateText() {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let elapsedTime = currentTime - self.startTime
        let timeRemaining = max(self.duration - elapsedTime, 0)
        
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        
        self.text = String(format: "%02d:%02d before \(dateFormatter.string(from: endTime))", minutes, seconds)
        
        if timeRemaining > 0 {
            let waitAction = SKAction.wait(forDuration: 1)
            let updateAction = SKAction.run {[weak self] in
                self?.updateText()
            }
            self.run(SKAction.sequence([waitAction, updateAction]))
        }
    }
}

