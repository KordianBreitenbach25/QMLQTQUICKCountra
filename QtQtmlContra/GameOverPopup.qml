import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Popup {
    id: gameOver
    width: parent.width
    height: parent.height
    modal: true
      property int livess
    visible: livess <= 0
    Item {
        width: parent.width
        height: parent.height
         //tablica stanów
        states: [
               State {
                   name: "state1"
                   PropertyChanges { target: rectangle; color: "green" }
               },
               State {
                   name: "state2"
                   PropertyChanges { target: rectangle; color: "blue" }
               }
           ]
    Rectangle {
        id:rectangle
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
    Button {
        text: "change color of menu"
         onClicked: {parent.state = parent.state === "state1" ? "state2" : "state1"}
    }
    }
  }
