import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "2D Shooting Game"
    property bool isMoving: false
    property bool gameStarted: false
    property bool shoot:false
    property bool lefty: false
    property bool righty: false
    property string moveDirection: ""  // "left" or "right"
    property real yPosition: 100   // Set an initial yPosition in the air
    property real score: 0
    property real lives: 3
    property real yVelocity: 0
    property real gravity: 0.5
    property real jumpVelocity: -10  // Negative velocity for upward movement
    property real movementSpeed: 10  // Pixels per second
    property real moveDuration: 200  // Milliseconds for fluid movement
   property bool functionEnabled: true
    Rectangle {
         id: gameArea
        width: parent.width
        height: parent.height
        Text {
              id: scoreDisplay
              text: "Score: " + score
              font.pixelSize: 20  // Adjust the font size as needed
              anchors.top: parent.top
              anchors.left: parent.left
              anchors.margins: 10  // Adjust the margin as needed
          }
        Text {
              id: livedisplay
              text: "lives: " + lives
              font.pixelSize: 20  // Adjust the font size as needed
              anchors.top: parent.top
              anchors.right: parent.right
              anchors.margins: 10  // Adjust the margin as needed
          }
        Popup {
            id: gameOver
            width: parent.width
            height: parent.height
            modal: true
            visible: lives <= 0

            Rectangle {
                width: parent.width
                height: parent.height
                color: "lightgray"

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                                   text: "Game Over"
                                   font.pixelSize: 24
                               }

                    Button {
                        text: "Exit"
                        onClicked: {
                            Qt.quit();
                        }
                    }
                }
            }
          }
        Popup {
              id: gameLauncherPopup
              width: parent.width
              height: parent.height
              modal: true
              visible: true

              Rectangle {
                  width: parent.width
                  height: parent.height
                  color: "lightgray"

                  Column {
                      anchors.centerIn: parent
                      spacing: 10

                      Button {
                          text: "Start Game"
                          onClicked: {
                              gameLauncherPopup.visible = false;
                              gameStarted=true;
                              // Dodaj tutaj kod do uruchomienia gry lub innych funkcji
                          }
                      }

                      Button {
                          text: "Exit"
                          onClicked: {
                              Qt.quit();
                          }
                      }
                  }
              }
          }


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
Item {   Timer {
    id: enemySpawnTimer
    interval: 2000  // Adjust the spawn interval as needed
    running: true
    repeat: true

    onTriggered: function spawnEnemy() {if(gameStarted==true){
        var enemyX = Math.random() * (gameArea.width - 20); // 20 is an example enemy width
        var enemy = Qt.createQmlObject(
            'import QtQuick 2.15;import QtQuick.Controls 2.15; Rectangle {objectName: "enemy"; id:enemy; width: 20; height: 30; color: "blue";
               x: ' + enemyX + '; y: 0;

NumberAnimation on x {
   to:enemy.x; // Absolute position for the x-axis
    duration: 1000
}
NumberAnimation on y {
     to: gameArea.height - height;
    duration: 5000
}
NumberAnimation on opacity {
        to: 0;
        duration: 10000;
        onRunningChanged: {
            if (!running) {
                console.log("Destroying...");
                projectile.destroy();
            }
        }
    }
            }', gameArea);






    }}
}          Timer {
        id: spawnTimer
        interval: 1
        running: functionEnabled
        repeat: true

        onTriggered:

            function spawnProjectile() {
                if (shoot) {
                    var projectileX = gameElement.x + (gameElement.width - 10) / 2; // 10 to szerokość pocisku
                    var projectileY = gameElement.y + (gameElement.height - 10) / 2; // 10 to wysokość pocisku
                       console.log("someting should happen now");
                       var projectile = Qt.createQmlObject(
                        'import QtQuick 2.15; import QtQuick.Controls 2.15; Rectangle {objectName: "projectile"; id:projectile; width: 10; height: 10; color: "yellow"; radius: 5;
                           x: ' + projectileX + ';
                           y: ' + projectileY + ';
                         RotationAnimation on rotation {
                        id: rotationAnimation
                        target: projectile
                        property: "rotation"

                        from: 0
                        to: 1000
                        duration: 1000
                        loops: Animation.Infinite
                    }
NumberAnimation on x {
to:projectile.x; // Absolute position for the x-axis
duration: 1000
}
NumberAnimation on y {
 to:  gameArea.y;
duration: 1000
}
NumberAnimation on opacity {
    to: 0;
    duration: 2000;
    onRunningChanged: {
        if (!running) {
            console.log("Destroying...");
            projectile.destroy();
        }
    }
}

}

',gameArea);







                }
            }




    }


    Timer {
        interval: 50 // Check for collisions frequently
        running: true
        repeat: true

        onTriggered:     function checkCollisions() {
            function findProjectiles() {
                var foundProjectiles = [];
                for (var i = 0; i < gameArea.children.length; i++) {
                    var child = gameArea.children[i];
                    if (child.objectName === "projectile") {
                        foundProjectiles.push(child);
                    }
                }
                return foundProjectiles;
            }
            function findEnemies() {
                var foundEnemies = [];
                for (var i = 0; i < gameArea.children.length; i++) {
                    var child = gameArea.children[i];
                    if (child.objectName === "enemy") {
                        foundEnemies.push(child);
                    }
                }
                return foundEnemies;
            }
            var projectiles = findProjectiles();
            var enemies =  findEnemies();
            for (var k = 0; k < enemies.length; k++) {

                  if (enemies[k].y + enemies[k].height >= gameArea.height) {
                      enemies[k].destroy();
                      lives-=1;
                  }
              }
            for (var i = 0; i < projectiles.length; i++) {
                for (var j = 0; j < enemies.length; j++) {
                    if (projectiles[i].x < enemies[j].x + enemies[j].width &&
                        projectiles[i].x + projectiles[i].width > enemies[j].x &&
                        projectiles[i].y < enemies[j].y + enemies[j].height &&
                        projectiles[i].y + projectiles[i].height > enemies[j].y) {
                        // Collision detected
                        projectiles[i].destroy();
                        enemies[j].destroy();
                        score+=1;
                    }
                }
            }
        }
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
                   (event.key === Qt.Key_A ? lefty=true  : righty=true );

                   if (event.key === Qt.Key_A) {

                          moveDirection = "left";
                      } else if (event.key === Qt.Key_D) {

                          moveDirection = "right";
                      }

               } else if (event.key === Qt.Key_Space && yPosition + gameElement.height === floor.y) {
                   // Jump if on the floor
                   yVelocity = jumpVelocity;
                   console.log("jump");
               } else  if(event.key === Qt.Key_Z){
                   shoot=true;
                        console.log("u started pressing z");
                   }
           }

           Keys.onReleased: {
               if (event.key === Qt.Key_A || event.key === Qt.Key_D||event.key === Qt.Key_Z) {
                   event.accepted = true;  // Accept the event to prevent forwarding
                   isMoving = false;
                   lefty=false;
                   righty=false;
                   if(event.key === Qt.Key_Z){
                   shoot=false;
                   console.log("ustopped pressing z");
                   }
               }
           }

           Keys.forwardTo: gameElement  // Forward keys to gameElement
       }
}
