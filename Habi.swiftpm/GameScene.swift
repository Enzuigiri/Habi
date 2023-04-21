//
//  GameScene.swift
//  Habi
//
//  Created by Enzu Ao on 14/04/23.
//

import SwiftUI
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var currentRoutineVM: CurrentRoutineViewModel?
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    // Player
    var player: SKSpriteNode!
    var playerMagicAreaNode: SKSpriteNode!
    
    
    private var playerAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "SpritesMC")
    }
    
    private var playerTexture: SKTexture {
        return playerAtlas.textureNamed("player")
    }
    
    private var playerIdleTexture: [SKTexture] {
        return [
            playerAtlas.textureNamed("idle_0"),
            playerAtlas.textureNamed("idle_1"),
            playerAtlas.textureNamed("idle_2"),
            playerAtlas.textureNamed("idle_3"),
            playerAtlas.textureNamed("idle_4"),
            playerAtlas.textureNamed("idle_3"),
            playerAtlas.textureNamed("idle_2"),
            playerAtlas.textureNamed("idle_1"),
        ]
    }
    
    private var playerRunningTexture: [SKTexture] {
        return [
            playerAtlas.textureNamed("running_0"),
            playerAtlas.textureNamed("running_1"),
            playerAtlas.textureNamed("running_2"),
            playerAtlas.textureNamed("running_3"),
            playerAtlas.textureNamed("running_4"),
            playerAtlas.textureNamed("running_5"),
            playerAtlas.textureNamed("running_6"),
            playerAtlas.textureNamed("running_7")
        ]
    }
    
    private var playerWalkingTexture: [SKTexture] {
        return [
            playerAtlas.textureNamed("walking_0"),
            playerAtlas.textureNamed("walking_1"),
            playerAtlas.textureNamed("walking_2"),
            playerAtlas.textureNamed("walking_3"),
            playerAtlas.textureNamed("walking_4"),
            playerAtlas.textureNamed("walking_5"),
            playerAtlas.textureNamed("walking_6"),
            playerAtlas.textureNamed("walking_7")
        ]
    }
    
    private var playerMagicAttackTexture: [SKTexture] {
        return [
            playerAtlas.textureNamed("magicAttack_0"),
            playerAtlas.textureNamed("magicAttack_1"),
            playerAtlas.textureNamed("magicAttack_2"),
            playerAtlas.textureNamed("magicAttack_3"),
            playerAtlas.textureNamed("magicAttack_4"),
            playerAtlas.textureNamed("magicAttack_5"),
            playerAtlas.textureNamed("magicAttack_6"),
            playerAtlas.textureNamed("magicAttack_7")
        ]
    }
    
    private var playerMagicEffectTexture: [SKTexture] {
        return [
            playerAtlas.textureNamed("magicEffect_0"),
            playerAtlas.textureNamed("magicEffect_1"),
            playerAtlas.textureNamed("magicEffect_2"),
            playerAtlas.textureNamed("magicEffect_3"),
            playerAtlas.textureNamed("magicEffect_4"),
            playerAtlas.textureNamed("magicEffect_5"),
            playerAtlas.textureNamed("magicEffect_6"),
            playerAtlas.textureNamed("magicEffect_7"),
            playerAtlas.textureNamed("magicEffect_8"),
            playerAtlas.textureNamed("magicEffect_9"),
            playerAtlas.textureNamed("magicEffect_10")
        ]
    }
    
    var playerSize = CGSize(width: 128, height: 128)
    
    var enemy: SKSpriteNode!
    
    private var enemyAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "SpritesMonster")
    }
    
    private var enemyTexture: SKTexture {
        return enemyAtlas.textureNamed("enemy")
    }
    
    private var enemyIdleTexture: [SKTexture] {
        return [
            enemyAtlas.textureNamed("Idle_0"),
            enemyAtlas.textureNamed("Idle_1"),
            enemyAtlas.textureNamed("Idle_2"),
            enemyAtlas.textureNamed("Idle_3"),
            enemyAtlas.textureNamed("Idle_4"),
            enemyAtlas.textureNamed("Idle_5"),
            enemyAtlas.textureNamed("Idle_6"),
            enemyAtlas.textureNamed("Idle_7"),
            enemyAtlas.textureNamed("Idle_8"),
            enemyAtlas.textureNamed("Idle_9"),
            enemyAtlas.textureNamed("Idle_10"),
            enemyAtlas.textureNamed("Idle_11")
        ]
    }
    
    private var enemySummonTexture: [SKTexture] {
        return [
            enemyAtlas.textureNamed("Summon_0"),
            enemyAtlas.textureNamed("Summon_1"),
            enemyAtlas.textureNamed("Summon_2"),
            enemyAtlas.textureNamed("Summon_3"),
            enemyAtlas.textureNamed("Summon_4"),
            enemyAtlas.textureNamed("Summon_5"),
            enemyAtlas.textureNamed("Summon_6"),
            enemyAtlas.textureNamed("Summon_7"),
            enemyAtlas.textureNamed("Summon_8"),
            enemyAtlas.textureNamed("Summon_9"),
        ]
    }
    
    private var enemyHurtTexture: [SKTexture] {
        return [
            enemyAtlas.textureNamed("Hurt_0"),
            enemyAtlas.textureNamed("Hurt_1"),
            enemyAtlas.textureNamed("Hurt_2"),
            enemyAtlas.textureNamed("Hurt_3"),
            enemyAtlas.textureNamed("Hurt_4"),
            enemyAtlas.textureNamed("Hurt_5"),
            enemyAtlas.textureNamed("Hurt_6"),
            enemyAtlas.textureNamed("Hurt_7"),
            enemyAtlas.textureNamed("Hurt_8"),
            enemyAtlas.textureNamed("Hurt_9"),
            enemyAtlas.textureNamed("Hurt_10"),
            enemyAtlas.textureNamed("Hurt_11")
        ]
    }
    
    private var enemyTauntTexture: [SKTexture] {
        return [
            enemyAtlas.textureNamed("Taunt_0"),
            enemyAtlas.textureNamed("Taunt_1"),
            enemyAtlas.textureNamed("Taunt_2"),
            enemyAtlas.textureNamed("Taunt_3"),
            enemyAtlas.textureNamed("Taunt_4"),
            enemyAtlas.textureNamed("Taunt_5"),
            enemyAtlas.textureNamed("Taunt_6"),
            enemyAtlas.textureNamed("Taunt_7"),
            enemyAtlas.textureNamed("Taunt_8"),
            enemyAtlas.textureNamed("Taunt_9"),
            enemyAtlas.textureNamed("Taunt_10"),
            enemyAtlas.textureNamed("Taunt_11"),
            enemyAtlas.textureNamed("Taunt_12"),
            enemyAtlas.textureNamed("Taunt_13"),
            enemyAtlas.textureNamed("Taunt_14"),
            enemyAtlas.textureNamed("Taunt_15"),
            enemyAtlas.textureNamed("Taunt_16"),
            enemyAtlas.textureNamed("Taunt_17")
        ]
    }
    
    var enemySize = CGSize(width: 128, height: 100)
    
    
    var rocket = SKSpriteNode()
    var rocketSize = CGSize(width: 50, height: 50)
    
    var rocketEnemy = SKSpriteNode()
    var rocketEnemySize = CGSize(width: 50, height: 50)
    
    // Sky Backgound
    var skyNode : SKSpriteNode
    var skyNodeNext : SKSpriteNode
    
    // Cloud Backgound
    var cloudNodes : [SKSpriteNode] = []
    
    // Foreground Hills Backgound
    var hillNodes : [SKSpriteNode] = []
    
    // Background Hills Backgound
    var distantHillNodes : [SKSpriteNode] = []
    
    // Ground
    var groundLevel = SKSpriteNode()
    var groundLevelSize = CGSize(width: 10000, height: 10)
    
    var count: Double = 1000
    
    // Time of last frame
    var lastFrameTime : TimeInterval = 0
    
    // Time since last frame
    var deltaTime : TimeInterval = 0
    
    var isHealthBarActive: Bool = false
    
    var isRunning: Bool = false
    
    var healthBar: [HealthBarNode] = []
    
    var tempHealthBarID: String = ""
    
    
    override init(size: CGSize) {
        
        skyNode = SKSpriteNode(texture: SKTexture(imageNamed: "Sky"))
        skyNode.position = CGPoint(x: size.width / 3.5, y: size.height / 3.5)
        skyNode.size = CGSize(width: skyNode.size.width, height: screenHeight/2+300)
        
        skyNodeNext = skyNode.copy() as! SKSpriteNode
        skyNodeNext.position = CGPoint(x: skyNode.position.x + skyNode.size.width,
                                       y: skyNode.position.y)
        
        cloudNodes.append(SKSpriteNode(texture: SKTexture(imageNamed: "Cloud")))
        cloudNodes[0].position = CGPoint(x: size.width / 3.5, y: size.height / 3.5)
        GameScene.multiplySpriteNodes(sprites: &cloudNodes)
        
        distantHillNodes.append(SKSpriteNode(texture: SKTexture(imageNamed: "DistantHills")))
        distantHillNodes[0].position = CGPoint(x: size.width / 3.5, y: size.height / 3.5)
        GameScene.multiplySpriteNodes(sprites: &distantHillNodes)
        
        hillNodes.append(SKSpriteNode(texture: SKTexture(imageNamed: "Hills")))
        hillNodes[0].position = CGPoint(x: size.width / 3.5, y: size.height / 3.5)
        GameScene.multiplySpriteNodes(sprites: &hillNodes)
        
        
        
        super.init(size: size)
        
        self.addChild(skyNode)
        self.addChild(skyNodeNext)
        
        for index in 0..<3{
            self.addChild(cloudNodes[index])
        }
        for index in 0..<3{
            self.addChild(distantHillNodes[index])
        }
        for index in 0..<3{
            self.addChild(hillNodes[index])
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func didMove(to view: SKView) {
        self.setUpPlayer()
        
        player.removeAllActions()
        
        
        self.startIdleToWalk()
        
        //        rocketEnemy = SKSpriteNode(color: .red, size: rocketEnemySize)
        //        rocketEnemy.position = CGPoint(x: (screenWidth > 900) ? screenWidth/2+250 : screenWidth/2+150, y: 100)
        //        rocketEnemy.name = "rocketEnemy"
        //        rocketEnemy.physicsBody = SKPhysicsBody(rectangleOf: rocketEnemySize)
        //        addChild(rocketEnemy)
        
        groundLevel = SKSpriteNode(color: .clear, size: groundLevelSize)
        groundLevel.position = CGPoint(x: 300, y: 5)
        groundLevel.name = "groundLevel"
        groundLevel.physicsBody = SKPhysicsBody(rectangleOf: groundLevelSize)
        groundLevel.physicsBody?.isDynamic = false
        addChild(groundLevel)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        //        if self.count >= 0 {
        //            healthBarNode.setProgress(CGFloat(count/1000))
        //            self.count-=1
        //        }
        
        
        addHealthBarIfRoutineStart()
        
        deltaTime = currentTime - lastFrameTime
        
        lastFrameTime = currentTime
        
        if player.action(forKey: "playerRunningAnimation") != nil {
            self.moveSprites(sprites: cloudNodes, speed: 20.0)
            self.moveSprites(sprites: distantHillNodes, speed: 50.0)
            self.moveSprites(sprites: hillNodes, speed: 150.0)
        } else if player.action(forKey: "playerWalkingAnimation") != nil {
            self.moveSprites(sprites: cloudNodes, speed: 10.0)
            self.moveSprites(sprites: distantHillNodes, speed: 16.0)
            self.moveSprites(sprites: hillNodes, speed: 50.0)
        }  else {
            self.moveSprites(sprites: cloudNodes, speed: 5.0)
            self.moveSprites(sprites: distantHillNodes, speed: 0.0)
            self.moveSprites(sprites: hillNodes, speed: 0.0)
        }
        
    }
    
    func addHealthBarIfRoutineStart() {
        if let currentRoutineVM = currentRoutineVM {
            let status = currentRoutineVM.currentRoutine.status
            
            if status.isEmpty || status == "pending" {
                return
            }
            
            let id = currentRoutineVM.currentRoutine.id
            if  (id == "active" || id != tempHealthBarID) && !isHealthBarActive {
                    tempHealthBarID = id
                    isRunning = false
                healthBar.append(HealthBarNode(size: CGSize(width: 350, height: 20), currentRoutineVM: currentRoutineVM))
                    healthBar[0].position = CGPoint(x: frame.midX, y: (frame.maxY > 530) ? frame.maxY - 220 : frame.maxY - 50)
                    addChild(healthBar[0])
                
                    player.removeAllActions()
                    setUpEnemy()
                    startSummonEnemyAnimation()
                    startMagicAttack()
                    
                    isHealthBarActive = true
            }
            
            if (id == "" || id != tempHealthBarID) && !healthBar.isEmpty {
                enemy.removeFromParent()
                player.removeAllActions()
                healthBar[0].removeFromParent()
                healthBar.removeAll()
                startIdleToWalk()
                isHealthBarActive = false
            }
        }
    }
    
//    func didReceiveCurrentRoutine() {
//        print("tesDid")
//        self.startRunningAnimation()
//    }
    
    private func setUpPlayer() {
        
        player = SKSpriteNode(texture: playerTexture, size: playerSize)
        player.position = CGPoint(x: (screenWidth > 900) ? screenWidth/2-250 : screenWidth/2-150, y: 70)
        player.name = "player"
        player.physicsBody = SKPhysicsBody(rectangleOf: playerSize)
        
        addChild(player)
    }
    
    func isRoutineStartingSoon(startTime: Date) -> Bool {
        let currentTime = Date()
        let timeInterval = startTime.timeIntervalSince(currentTime)
        return timeInterval >= -3600 &&  timeInterval <= 0
    }
    
    func startIdleAnimation() {
        let playerIdleAnimation = SKAction.animate(with: playerIdleTexture, timePerFrame: 0.1)
        
        player.run(SKAction.repeatForever(playerIdleAnimation), withKey: "playerIdleAnimation")
    }
    
    func startRunningAnimation() {
        let playerRunningAnimation = SKAction.animate(with: playerRunningTexture, timePerFrame: 0.07)
        
        player.run(SKAction.repeatForever(playerRunningAnimation), withKey: "playerRunningAnimation")
    }
    
    func removeAllAnimation() {
        player.removeAllActions()
        enemy.removeAllActions()
    }
    
    func startWalkingAnimation() {
        let playerWalkingAnimation = SKAction.animate(with: playerWalkingTexture, timePerFrame: 0.1)
        
        player.run(SKAction.repeatForever(playerWalkingAnimation), withKey: "playerWalkingAnimation")
    }
    
    private func startIdleToWalk() {
        let idleAnimation = SKAction.animate(with: playerIdleTexture, timePerFrame: 0.12)
        let walkAnimation = SKAction.animate(with: playerWalkingTexture, timePerFrame: 0.1)
        let playerRunningAnimation = SKAction.animate(with: playerRunningTexture, timePerFrame: 0.07)
        
        let idleAction = SKAction.run {
            self.player.run(SKAction.repeatForever(idleAnimation), withKey: "playerIdleAnimation")
        }
        
        let walkAction = SKAction.run {
            self.player.run(SKAction.repeatForever(walkAnimation), withKey: "playerWalkingAnimation")
        }
        
        let runningAction = SKAction.run {
            self.player.run(SKAction.repeatForever(playerRunningAnimation), withKey: "playerRunningAnimation")
        }
        
        let delayAction = SKAction.wait(forDuration: 10.0)
        let walkingDelayAction = SKAction.wait(forDuration: 5.0)
        
        let removeIdleAction = SKAction.run {
            self.player.removeAction(forKey: "playerIdleAnimation")
        }
        
        let removeWalkAction = SKAction.run {
            self.player.removeAction(forKey: "playerWalkingAnimation")
        }
        
        let removeRunningAction = SKAction.run {
            self.player.removeAction(forKey: "playerRunningAnimation")
        }
        
        let sequence = SKAction.sequence([idleAction, delayAction, removeIdleAction, walkAction,
                                          walkingDelayAction, removeWalkAction, runningAction, delayAction,
                                          removeRunningAction, walkAction, walkingDelayAction, removeWalkAction
                                         ])
        
        let repeatSequence = SKAction.repeatForever(sequence)
        
        player.run(repeatSequence)
    }
    
    private func startMagicAttack() {
        let attackAnimation = SKAction.animate(with: playerMagicAttackTexture, timePerFrame: 0.1)
        let magicEffectAnimation = SKAction.animate(with: playerMagicEffectTexture, timePerFrame: 0.1)
        let idleAnimation = SKAction.animate(with: playerIdleTexture, timePerFrame: 0.15)
        let enemyHurtAnimation = SKAction.animate(with: enemyHurtTexture, timePerFrame: 0.05)
        
        let delayAction = SKAction.wait(forDuration: 2)
        
        let effectAction = SKAction.run {
            self.playerMagicAreaNode.run(magicEffectAnimation, withKey: "magicEffect")
        }
        
        let enemyHurtAction = SKAction.run {
            self.enemy.run(enemyHurtAnimation, withKey: "enemyHurtAnimation")
        }
        
        let idleAction = SKAction.run {
            self.player.run(SKAction.repeatForever(idleAnimation), withKey: "playerIdleAnimation")
        }
        
        let removeIdleAction = SKAction.run {
            self.player.removeAction(forKey: "playerIdleAnimation")
        }
        
        let containerAction = SKAction.group([attackAnimation, effectAction, enemyHurtAction])
        
        let sequence = SKAction.sequence([containerAction, idleAction, delayAction, removeIdleAction])
        
        player.run(SKAction.repeatForever(sequence))
    }

    
    private func setUpEnemy() {
        enemy = SKSpriteNode(texture: enemyTexture, size: enemySize)
        enemy.position = CGPoint(x: (screenWidth > 900) ? screenWidth/2+250 : screenWidth/2+150, y: 128)
        enemy.name = "enemy"
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemySize)
        enemy.xScale = -1.0
        enemy.zPosition = 0
        
        addChild(enemy)
        
        playerMagicAreaNode = SKSpriteNode(color: .clear, size: enemySize)
        playerMagicAreaNode.position = CGPoint(x: enemy.position.x, y: 60)
        playerMagicAreaNode.name = "playerMagicArea"
        playerMagicAreaNode.zPosition = 1
        
        addChild(playerMagicAreaNode)
    }
    
    private func startSummonEnemyAnimation() {
        let enemyTauntAnimation = SKAction.animate(with: enemyTauntTexture, timePerFrame: 0.1)
        let enemySummonAnimation = SKAction.animate(with: enemySummonTexture, timePerFrame: 0.1)
        
        enemy.run(enemySummonAnimation) {
            self.enemy.run(SKAction.repeatForever(enemyTauntAnimation), withKey: "enemyTauntAnimation")
        }
    }
    
    private func startEnemyHurtAnimation() {
        let enemyHurtAnimation = SKAction.animate(with: enemyHurtTexture, timePerFrame: 0.05)
        
        enemy.run(enemyHurtAnimation, withKey: "enemyHurtAnimation")
    }
    
    static func multiplySpriteNodes(sprites: inout [SKSpriteNode]){
        for index in 1..<3 {
            sprites.append(sprites[0].copy() as! SKSpriteNode)
            sprites[index].position = CGPoint(x: sprites[0].position.x + sprites[0].size.width * CGFloat(index),
                                              y: sprites[0].position.y)
        }
    }
    
    
    func moveSprites(sprites : [SKSpriteNode], speed : Float) -> Void {
        var newPosition = CGPointZero
        
        for spriteToMove in sprites {
            
            newPosition = spriteToMove.position
            newPosition.x -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            if spriteToMove.frame.maxX < self.frame.minX {
                
                spriteToMove.position =
                CGPoint(x: spriteToMove.position.x +
                        spriteToMove.size.width * 3,
                        y: spriteToMove.position.y)
            }
            
        }
    }
}
