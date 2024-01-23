import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQtmlContra
Popup {
      id: gameLauncherPopup
      width: parent.width
      height: parent.height
      modal: true
      visible: true
      property bool gameStarteds: false
          property real spawnIntervals: 2000




          ListModel {
              id: difficultyModel
              ListElement { label: "play Hard"; interval:200 }
              ListElement { label: "play Easy"; interval: 2000 }
              // Można dodać więcej poziomów trudności tutaj
          }
      Rectangle {
          id: rectangl
          width: parent.width
          height: parent.height
          color: "lightgray"

          Column {
              anchors.centerIn: parent
              spacing: 10
              ListView {
                  width: parent.width
                   height: 100
                  model: difficultyModel  // Tutaj następuje połączenie ListView z ListModel
                  delegate: Button {
                      text: model.label
                      onClicked: {

                          spawnIntervals = model.interval
                          gameLauncherPopup.visible = false
                          gameStarted = true
                          // Dodaj tutaj kod do uruchomienia gry lub innych funkcji
                      }
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
