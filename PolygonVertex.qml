import QtQuick 2.15
import QtPositioning 5.15
import QtLocation 5.15

MapQuickItem {
    z: 100

    anchorPoint.x: shape.width/2
    anchorPoint.y: shape.height/2

    required property var coord
    required property int index
    required property var model
    required property var map

    coordinate: coord

    property bool hovered: false
    property bool captured: false

    signal deleteRequested(index: int);

    //update model
    onCoordinateChanged: {
        model.coord = coordinate;
    }

    //Circle shape which represents polygon vertex
    sourceItem: Rectangle {
        id: shape
        height: 20
        width: 20
        radius: height*0.5

        border.width: 3
        border.color: "#ccf57627"
        color: {hovered ? "#787ff527" : "#78f57627"}
    }

    //Handle hover and drag events
    MouseArea {
        acceptedButtons: Qt.LeftButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 2
        height: parent.height * 2
        hoverEnabled: true
        drag.target: parent
        drag.smoothed: false
        preventStealing: true
        onEntered: {
            hovered = true;
            map.gesture.enabled = false;
        }
        onExited: {
            hovered = false;
            map.gesture.enabled = true;
        }
    }

    //Handle click (delete) events
    MouseArea {
        acceptedButtons: Qt.RightButton
        anchors.fill: parent
        preventStealing: true
        onClicked: {
            if(mouse.button === Qt.RightButton) {
                deleteRequested(index)
                map.gesture.enabled = true;
            }
        }
    }

}
