//
//  GameOver.swift
//  EunseoAdventure
//
//  Created by junwoo on 14/11/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
  
  override func sceneDidLoad() {
    
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
      let level1 = GameScene(fileNamed: "Level1")
      self.view?.presentScene(level1)
      self.removeAllActions()
    }
  }
}
