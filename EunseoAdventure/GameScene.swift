//
//  GameScene.swift
//  EunseoAdventure
//
//  Created by junwoo on 09/11/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
  //node
  var player: SKNode?
  var joystick: SKNode?
  var knob: SKNode?
  var cameraNode: SKCameraNode?
  var mountain1: SKNode?
  var mountain2: SKNode?
  var mountain3: SKNode?
  var moon: SKNode?
  var stars: SKNode?
  
  
  //boolean
  var isJoystickActing = false
  var rewardIsNotTouched = true
  var isHit = false
  
  //measure
  var knobRadius: CGFloat = 50.0
  
  //score
  let scoreLabel = SKLabelNode()
  var score = 0
  
  //life
  var heartsArray = [SKSpriteNode]()
  var heartContainer = SKSpriteNode()
  
  //sprite engine
  var previousTimeInterval: TimeInterval = 0
  var isPlayerFacingRight = true
  let playerSpeed: Double = 4
  
  //player state
  var playerStateMachine: GKStateMachine!
  
  //viewdidload
  override func didMove(to view: SKView) {
    physicsWorld.contactDelegate = self
    
    player = childNode(withName: "player")
    joystick = childNode(withName: "joystick")
    knob = joystick?.childNode(withName: "knob")
    cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
    mountain1 = childNode(withName: "mountain1")
    mountain2 = childNode(withName: "mountain2")
    mountain3 = childNode(withName: "mountain3")
    moon = childNode(withName: "moon")
    stars = childNode(withName: "stars")
    
    //life
    heartContainer.position = CGPoint(x: -300, y: 140)
    heartContainer.zPosition = 5
    cameraNode?.addChild(heartContainer)
    fillHearts(count: 3)
    
    playerStateMachine = GKStateMachine(states: [
      JumpingState(playerNode: player!),
      WalkingState(playerNode: player!),
      IdleState(playerNode: player!),
      LandingState(playerNode: player!),
      StunnedState(playerNode: player!)
      ])
    
    //멍때리는 상태로 시작
    playerStateMachine.enter(IdleState.self)
    
    //timer
    Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
      self.spawnMeteor()
    }
    
    scoreLabel.position = CGPoint(x: (cameraNode?.position.x)! + 310, y: 140)
    scoreLabel.fontColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
    scoreLabel.fontSize = 24
    scoreLabel.fontName = "AvenirNext-Bold"
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.text = String(score)
    cameraNode?.addChild(scoreLabel)
    
    //background music
//    let soundAction = SKAction.repeatForever(SKAction.playSoundFileNamed("music.wav",
//                                                                         waitForCompletion: false))
//    run(soundAction)
  }
}

//touches
extension GameScene {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      if let knob = knob {
        let location = touch.location(in: joystick!)
        isJoystickActing = knob.frame.contains(location)
      }
      
      let location = touch.location(in: self)
      
      //바깥 터치하면 플레이어 점프
      if !(joystick?.contains(location))! {
        playerStateMachine.enter(JumpingState.self)
        run(Sound.jump.action)
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let joystick = joystick else { return }
    guard let knob = knob else { return }
    if !isJoystickActing { return }
    
    //distance
    for touch in touches {
      let position = touch.location(in: joystick)
      let length = sqrt(pow(position.x, 2) + pow(position.y, 2))
      
      //지정된 x, y 좌표의 아크탄젠트, 즉 역 탄젠트 값을 반환합니다. 아크탄젠트 값은 원점(0, 0)에서 좌표(x_num, y_num)까지의 선과 X축이 이루는 각도입니다.
      //이 각도는 -pi와 pi 사이의 라디안(-pi 제외)으로 표시됩니다.
      let angle = atan2(position.y, position.x)
      
      //knob 의 활동반경을 제한
      if knobRadius > length {
        knob.position = position
      } else {
        knob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let currentX = touch.location(in: joystick!).x
      let xLimit: CGFloat = 200.0
      if currentX > -xLimit && currentX < xLimit {
        resetKnobPosition()
      }
    }
  }
}


//action
extension GameScene {
  func resetKnobPosition() {
    let initialPoint = CGPoint(x: 0, y: 0)
    let moveBackAction = SKAction.move(to: initialPoint, duration: 0.1)
    moveBackAction.timingMode = .linear
    knob?.run(moveBackAction)
    isJoystickActing = false
  }
  
  func rewardTouch() {
    score += 1
    scoreLabel.text = String(score)
  }
  
  func fillHearts(count: Int) {
    for index in 1...count {
      let heart = SKSpriteNode(imageNamed: "heart")
      let xPosition = heart.size.width * CGFloat(index - 1)
      heart.position = CGPoint(x: xPosition, y: 0)
      heartsArray.append(heart)
      heartContainer.addChild(heart)
    }
  }
  
  func loseHeart() {
    if isHit {
      let lastElementIndex = heartsArray.count - 1
      if heartsArray.indices.contains(lastElementIndex - 1) {
        let lastHeart = heartsArray[lastElementIndex]
        lastHeart.removeFromParent()
        heartsArray.remove(at: lastElementIndex)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
          self.isHit = false
        }
      } else {
        dying()
        showDyingScene()
      }
      
      invincible()
    }
  }
  
  //죽고나서 2초동안은 무적 상태
  func invincible() {
    player?.physicsBody?.categoryBitMask = 0
    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
      self.player?.physicsBody?.categoryBitMask = 2
    }
  }
  
  func dying() {
    //시작위치로
    let dieAction = SKAction.move(to: CGPoint(x: -300, y: -100), duration: 0.1)
    player?.run(dieAction)
    self.removeAllActions()
    
    fillHearts(count: 3)
  }
  
  func showDyingScene() {
    let gameOverScene = GameScene(fileNamed: "GameOver")
    self.view?.presentScene(gameOverScene)
    
  }
}

//gameloop
extension GameScene {
  override func update(_ currentTime: TimeInterval) {
    let deltaTime = currentTime - previousTimeInterval
    previousTimeInterval = currentTime
    
    rewardIsNotTouched = true
    
    //camera
    cameraNode?.position.x = player!.position.x
    joystick?.position.y = (cameraNode?.position.y)! - 100
    joystick?.position.x = (cameraNode?.position.x)! - 300
    
    //player Movement
    guard let knob = knob else { return }
    let xPosition = Double(knob.position.x)
    
    //걸어다니는 애니메이션
    let positivePosition = xPosition > 0 ? -xPosition : xPosition
    if floor(positivePosition) != 0 {
      playerStateMachine.enter(WalkingState.self)
    } else {
      playerStateMachine.enter(IdleState.self)
    }
    
    let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
    let moveAction = SKAction.move(by: displacement, duration: 0)
    let totalAction: SKAction!
    let isMovingRight = xPosition > 0
    let isMovingLeft = xPosition < 0
    if isMovingLeft && isPlayerFacingRight {
      isPlayerFacingRight = false
      let faceAction = SKAction.scaleX(to: -1, duration: 0)
      totalAction = SKAction.sequence([moveAction, faceAction])
    } else if isMovingRight && !isPlayerFacingRight {
      isPlayerFacingRight = true
      let faceAction = SKAction.scaleX(to: 1, duration: 0)
      totalAction = SKAction.sequence([moveAction, faceAction])
    } else {
      totalAction = moveAction
    }
    player?.run(totalAction)
    
    
    //background animation
    let parallax1 = SKAction.moveTo(x: (player?.position.x)!/(-10), duration: 0)
    mountain1?.run(parallax1)
    let parallax2 = SKAction.moveTo(x: (player?.position.x)!/(-20), duration: 0)
    mountain2?.run(parallax2)
    let parallax3 = SKAction.moveTo(x: (player?.position.x)!/(-40), duration: 0)
    mountain3?.run(parallax3)
    
    let parallax4 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 0)
    moon?.run(parallax4)
    
    let parallax5 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 0)
    stars?.run(parallax5)
  }
}

//collision
extension GameScene: SKPhysicsContactDelegate {
  
  struct Collision {
    
    enum Masks: Int {
      case killing, player, reward, ground
      var bitmask: UInt32 {
        return 1 << self.rawValue
      }
    }
    
    let masks: (first: UInt32, second: UInt32)
    
    func matches(_ first: Masks, _ second: Masks) -> Bool {
      return (first.bitmask == masks.first && second.bitmask == masks.second) ||
        (first.bitmask == masks.second && second.bitmask == masks.first)
    }
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let collision = Collision(masks: (first: contact.bodyA.categoryBitMask,
                                      second: contact.bodyB.categoryBitMask))
    
    //플레이어가 트랩에 부딪히면 시작 위치로
    if collision.matches(.player, .killing) {
      loseHeart()
      isHit = true
      run(Sound.hit.action)
      playerStateMachine.enter(StunnedState.self)
    }
    
    if collision.matches(.player, .ground) {
      playerStateMachine.enter(LandingState.self)
    }
    
    if collision.matches(.player, .reward) {
      if contact.bodyA.node?.name == "jewel" {
        contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        contact.bodyA.node?.removeFromParent()
      }
      else if contact.bodyB.node?.name == "jewel" {
        contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        contact.bodyB.node?.removeFromParent()
      }
      
      if rewardIsNotTouched {
        rewardTouch()
        rewardIsNotTouched = false
      }
      run(Sound.reward.action)
    }
    
    //별똥별이 땅에 떨어지면 사라진다
    if collision.matches(.ground, .killing) {
      if contact.bodyA.node?.name == "Meteor", let meteor = contact.bodyA.node {
        createMolten(at: meteor.position)
        meteor.removeFromParent()
      }
      else if contact.bodyB.node?.name == "Meteor", let meteor = contact.bodyB.node {
        createMolten(at: meteor.position)
        meteor.removeFromParent()
      }
      run(Sound.meteorFalling.action)
    }
  }
}

//meteor
extension GameScene {
  
  func spawnMeteor() {
    let meteorNode = SKSpriteNode(imageNamed: "meteor")
    meteorNode.name = "Meteor"
    let randomXPosition = Int(arc4random_uniform(UInt32(self.size.width)))
    meteorNode.position = CGPoint(x: randomXPosition, y: 270)
    meteorNode.anchorPoint = CGPoint(x: 0.5, y: 1)
    meteorNode.zPosition = 5
    
    let physicsBody = SKPhysicsBody(circleOfRadius: 30)
    meteorNode.physicsBody = physicsBody
    physicsBody.categoryBitMask = Collision.Masks.killing.bitmask
    physicsBody.collisionBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
    physicsBody.contactTestBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
    physicsBody.fieldBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
    
    physicsBody.affectedByGravity = true
    physicsBody.allowsRotation = false
    physicsBody.restitution = 0.2
    physicsBody.friction = 10
    
    addChild(meteorNode)
  }
  
  func createMolten(at position: CGPoint) {
    let moltenNode = SKSpriteNode(imageNamed: "molten")
    moltenNode.position.x = position.x
    moltenNode.position.y = position.y - 60
    moltenNode.zPosition = 4
    
    addChild(moltenNode)
    
    let action = SKAction.sequence([
        SKAction.fadeIn(withDuration: 0.1),
        SKAction.wait(forDuration: 3),
        SKAction.fadeOut(withDuration: 0.2),
        SKAction.removeFromParent()
      ])
    
    moltenNode.run(action)
  }
}
