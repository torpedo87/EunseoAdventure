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
- didMove(to:) : Called immediately after a scene is presented by a view.
- update(TimeInterval) : Performs any scene-specific updates that need to occur before scene actions are evaluated.


## SKPhysicsContactDelegate

- Methods your app can implement to respond when physics bodies come into contact.

## SKPhysicsBody

- An object which adds physics simulation to a node.
- categoryBitMask : A mask that defines which categories this physics body belongs to. ( 내 번호)
- collisionBitMask : A mask that defines which categories of physics bodies can collide with this physics body. (충돌가능한 놈의 번호)
- contactTestBitMask : A mask that defines which categories of bodies cause intersection notifications with this physics body.
- fieldBitMask : A mask that defines which categories of physics fields can exert forces on this physics body.

## SKLabelNode
- A node that displays a text label.


--- 

# GamePlayKit

- logic
- Architect and organize your game logic. Incorporate common gameplay behaviors such as random number generation, artificial intelligence, pathfinding, and agent behavior.


## GKState

- The abstract superclass for defining state-specific logic as part of a state machine.


## GKStateMachine

- A finite-state machine—a collection of state objects that each define logic for a particular state of gameplay and rules for transitioning between states.


## didEnter(from:)

- Performs custom actions when a state machine transitions into this state.


## isValidNextState(_:)

- Returns a Boolean value indicating whether a state machine currently in this state is allowed to transition into the specified state.
