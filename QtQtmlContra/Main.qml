import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQtmlContra
ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "2D Shooting Game"
    //segment zmiennych
     property real spawnInterval:2000
    property bool isMoving: false
    property bool gameStarted: false
    property bool shoot:false
    property bool lefty: false
    property bool righty: false
    property string moveDirection: ""
    property real yPosition: 100
    property real yVelocity: 0
    property real gravity: 0.5
    property real jumpVelocity: -10
    property real movementSpeed: 10
    property real moveDuration: 200
   property bool functionEnabled: true
    property int max:0
    property int min:1
    property int score: max
    property int lives: min
    //fragment ściągający zmienne z kodu c++
    Backend {
     id:myBackend
        onNumberEmitted:(num,numb)=>{
                        max=num
                        min=numb
                        }

    }
    Component.onCompleted: {
         myBackend.generateNumber(3,3);
        }
//segment zmiennych
    Rectangle {
         id: gameArea
        width: parent.width
        height: parent.height
        //text pokazujący wynik
        Text {
              id: scoreDisplay
              text: "Score: " + score
              font.pixelSize: 20
              anchors.top: parent.top
              anchors.left: parent.left
              anchors.margins: 10
          }
         //text pokazujący życia
        Text {
              id: livedisplay
              text: "lives: " + lives
              font.pixelSize: 20
              anchors.top: parent.top
              anchors.right: parent.right
              anchors.margins: 10
          }

        //popup sygnalizujący koniec gry
        GameOverPopup {
                livess: lives
           }
        //popup będący menu gry
        GameLauncherPopup {

                gameStarteds:spawnInterval
                spawnIntervals:spawnInterval

            }
     //object gracza
        GameElement {
             id: gameElement
             floors: floor
            moveDirections:moveDirection
            isMovings:isMoving
            jumpVelocitys:jumpVelocity
            yVelocitys:yVelocity
         }
        //element  podłogi
        Rectangle {
            id: floor
            width: parent.width
            height: 50
            color: "lightblue"
            anchors.bottom: parent.bottom
        }
    }
Item {
    // funkcja spawnująca przeciwników i nadająca im ruch
    Timer {
    id: enemySpawnTimer
    interval: spawnInterval // Adjust the spawn interval as needed
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
}

     //funkcja spawnująca pociski
    Timer {
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
        interval: 50
        running: true
        repeat: true
            //loopy ładujące wszyskie obecne pociski i przeciwników
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
                 //sprawdzamy czy pocisk dotknął ziemie
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
                        // funkcja sprawdzająca czy pocisk zerzył się z przeciwnikiem
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
                //funkcje sprawdzające czy wcisneliśmy klawisze ruchu A D i spacja
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

               }  else  if(event.key === Qt.Key_Z){
                   shoot=true;
                        console.log("u started pressing z");
                   }
           }
            //funkcja sprawdzająca czy strzelamy za pomocą przycisku z
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

           Keys.forwardTo: gameElement
       }
}
