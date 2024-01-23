import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
Rectangle {
    id: gameElement
    width: 50
    height: 75
    color: "red"
    radius: 25
    property real yVelocitys: 0
      property real yPosition: 100
      property real gravity: 0.5
      property real jumpVelocitys: -10
      property real movementSpeed: 10
      property bool isMovings: false
      property string moveDirections: ""
      property var floors
    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            yVelocitys += gravity;
            yPosition += yVelocitys;


            if (yPosition + gameElement.height > floors.y) {
                yPosition = floors.y - gameElement.height;
                yVelocitys = 0;
            }

            gameElement.y = yPosition;
            onTriggered: {
                            if (isMovings) {
                                gameElement.x += (moveDirections === "left" ? -movementSpeed : movementSpeed);
                            }
                        }
        }
    }

    NumberAnimation {
        id: xAnimation
        target: gameElement
        property: "x"

    }


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
        else if (event.key === Qt.Key_Space && yPosition + gameElement.height == floor.y)

                       {
                           // Jump if on the floor
                           yVelocitys = jumpVelocitys;
                           console.log("jump");
                       }
    }


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

        yPosition = 100;
        gameElement.y = yPosition;
    }
}
