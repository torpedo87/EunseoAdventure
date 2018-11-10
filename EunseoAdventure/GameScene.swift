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
  
  //boolean
  var isJoystickActing = false
  
  //measure
  var knobRadius: CGFloat = 50.0
  
  //sprite engine
  var previousTimeInterval: TimeInterval = 0
  var isPlayerFacingRight = true
  let playerSpeed: Double = 4
  
  //viewdidload
  override func didMove(to view: SKView) {
    player = childNode(withName: "player")
    joystick = childNode(withName: "joystick")
    knob = joystick?.childNode(withName: "knob")
    
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
}

//gameloop
extension GameScene {
  override func update(_ currentTime: TimeInterval) {
    let deltaTime = currentTime - previousTimeInterval
    previousTimeInterval = currentTime
    
    //player Movement
    guard let knob = knob else { return }
    let xPosition = Double(knob.position.x)
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
  }
}
