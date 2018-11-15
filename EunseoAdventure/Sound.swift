//
//  Sound.swift
//  EunseoAdventure
//
//  Created by junwoo on 15/11/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import Foundation
import SpriteKit

enum Sound: String {
  case hit, jump, levelUp, meteorFalling, reward
  
  var action: SKAction {
    return SKAction.playSoundFileNamed(rawValue + "Sound.wav", waitForCompletion: false)
  }
}

//extension SKAction {
//  static let playGameMusic: SKAction = repeatForever(playSoundFileNamed("music.wav",
//                                                                        waitForCompletion: false))
//}
