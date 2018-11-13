#  SpriteKit
- visual
- Create 2D sprite-based games using an optimized animation system, physics simulation, and event-handling support.
- xCode project 생성시 game 템플릿을 선택하면 된다
- .sks 확장자 파일이 게임을 위한 scene 파일이다
- asset 을 scene에 추가할 때 media library 이용하는데 라이브러리 버튼을 롱프레스하면 선택가능하다


## SKView
- An object that displays SpriteKit content. This content is provided by an SKScene object.
- SKScene : The root node for all Sprite Kit objects displayed in a view.
- SKScene의 camera 이름을 camera 라고 하면 안되고 다른 이름 써야함

--- 

# GamePlayKit
- logic
- Architect and organize your game logic. Incorporate common gameplay behaviors such as random number generation, artificial intelligence, pathfinding, and agent behavior.

## GKState
- The abstract superclass for defining state-specific logic as part of a state machine.

## GKStateMachine
- A finite-state machine—a collection of state objects that each define logic for a particular state of gameplay and rules for transitioning between states.
