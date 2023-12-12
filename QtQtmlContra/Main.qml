import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "2D Shooting Game"
    property bool isMoving: false
    property string moveDirection: ""  // "left" or "right"
    property real yPosition: 100   // Set an initial yPosition in the air
    property real yVelocity: 0
    property real gravity: 0.5
    property real jumpVelocity: -10  // Negative velocity for upward movement
    property real movementSpeed: 20  // Pixels per second
    property real moveDuration: 200  // Milliseconds for fluid movement

    Rectangle {
        width: parent.width
        height: parent.height

        Rectangle {
            id: gameElement
            width: 50
            height: 75
            color: "red"
            radius: 25

            Timer {
                interval: 16
                running: true
                repeat: true
                onTriggered: {
                    yVelocity += gravity;
                    yPosition += yVelocity;

                    // Collision detection with the floor
                    if (yPosition + gameElement.height > floor.y) {
                        yPosition = floor.y - gameElement.height;
                        yVelocity = 0;
                    }

                    gameElement.y = yPosition;
                    onTriggered: {
                                    if (isMoving) {
                                        gameElement.x += (moveDirection === "left" ? -movementSpeed : movementSpeed);
                                    }
                                }
                }
            }

            NumberAnimation {
                id: xAnimation
                target: gameElement
                property: "x"

            }

            // Toggle between height and width while 'S' key is held down
            Keys.onPressed: {
                if (event.key === Qt.Key_S) {
                    event.accepted = true;
                    gameElement.width ^= gameElement.height;
                    gameElement.height ^= gameElement.width;
                    gameElement.width ^= gameElement.height;
                     movementSpeed=10;
                    if (event.key === Qt.Key_S) {
                        console.log("down");
                    }
                }
            }

            // Stop toggling when 'S' key is released
            Keys.onReleased: {
                if (event.key === Qt.Key_S) {
                    event.accepted = true;
                    gameElement.width ^= gameElement.height;
                    gameElement.height ^= gameElement.width;
                    gameElement.width ^= gameElement.height;
                     movementSpeed=20;
                }
            }

            onXChanged: {
                if (gameElement.x < 0) {
                    gameElement.x = 0;
                } else if (gameElement.x + gameElement.width > parent.width) {
                    gameElement.x = parent.width - gameElement.width;
                }
            }

            Component.onCompleted: {
                // Set the initial position
                yPosition = 100;  // Adjust this value based on your needs
                gameElement.y = yPosition;
            }
        }

        Rectangle {
            id: floor
            width: parent.width
            height: 50
            color: "lightblue"
            anchors.bottom: parent.bottom
        }
    }

    // Item for handling key events
    Item {
           anchors.fill: parent
           focus: true



           Keys.onPressed: {
               if (event.key === Qt.Key_A || event.key === Qt.Key_D) {
                   event.accepted = true;  // Accept the event to prevent forwarding
                   isMoving = true;
                   moveDirection = (event.key === Qt.Key_A ? "left" : "right");
               } else if (event.key === Qt.Key_Space && yPosition + gameElement.height === floor.y) {
                   // Jump if on the floor
                   yVelocity = jumpVelocity;
                   console.log("jump");
               }
           }

           Keys.onReleased: {
               if (event.key === Qt.Key_A || event.key === Qt.Key_D) {
                   event.accepted = true;  // Accept the event to prevent forwarding
                   isMoving = false;
               }
           }

           Keys.forwardTo: gameElement  // Forward keys to gameElement
       }
}
