import QtQuick 2.15
import QtQuick.Window 2.15
import QtPositioning 5.15

Window {
    width: 1280
    height: 729
    visible: true
    title: qsTr("GIS Polygons")

    OsmMap {
        anchors.fill: parent
    }
}
