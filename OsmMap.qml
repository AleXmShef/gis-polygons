import QtQuick 2.15
import QtPositioning 5.15
import QtLocation 5.15
import CustomModule 1.0

Item {
    anchors.fill: parent

    Plugin {
        id: plugin
        name: "osm"
    }

    Map {
        id: osmMap
        anchors.fill: parent
        plugin: plugin
        center: QtPositioning.coordinate(60.035080, 30.283177)
        zoomLevel: 17

        gesture.enabled: true
        gesture.preventStealing: true
        gesture.acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.PinchGesture

        property int hovered_edge_id: -1

        MapPolygon {
            id: polygon
            border.width: 3
            border.color: "#abf5a927"
            color: "#4fffa927"
        }

        MapPolyline {
            id: polygonEdge
            line.width: 3
            line.color: "#ab00ff00"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            //calculate distance from point (p) to line segment (v, w)
            function dist_squared(v, w) { return Math.pow((v.x - w.x), 2) + Math.pow((v.y - w.y), 2) }
            function distToSegment(p, v, w) {
                var l = dist_squared(v, w);
                if (l === 0) return dist_squared(p, v);
                var t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l;
                t = Math.max(0, Math.min(1, t));
                return Math.sqrt(dist_squared(p, { x: v.x + t * (w.x - v.x), y: v.y + t * (w.y - v.y) }));
            }

            //handle clicks
            onClicked: {
                //hovered on edge
                if(parent.hovered_edge_id > -1) {
                    coordinateModel.insertData(parent.hovered_edge_id + 1, osmMap.toCoordinate(Qt.point(mouse.x, mouse.y)));
                }
                //initial 3 points
                else if(coordinateModel.rowCount() < 3)
                    coordinateModel.insertData(coordinateModel.rowCount(), osmMap.toCoordinate(Qt.point(mouse.x, mouse.y)));
                overlayView.updatePolygon();
            }

            //check for cursor/edge proximity
            onPositionChanged: {
                let _id = -1;
                let _c1 = 0;
                let _c2 = 0;
                for(let i = 0; i < coordinateModel.rowCount(); i++) {
                    let c1 = coordinateModel.data(coordinateModel.index(i, 0));
                    let p1 = osmMap.fromCoordinate(c1);

                    let i2 = i === coordinateModel.rowCount() - 1 ? 0 : i + 1;
                    let c2 = coordinateModel.data(coordinateModel.index(i2, 0));
                    let p2 = osmMap.fromCoordinate(c2);

                    let dist = distToSegment(Qt.point(mouse.x, mouse.y), p1, p2);
                    if(dist < 10) {
                        _id = i;
                        _c1 = c1;
                        _c2 = c2;
                    }
                }
                parent.hovered_edge_id = _id;
                if(parent.hovered_edge_id > -1)
                    polygonEdge.path = [_c1, _c2];
                else
                    polygonEdge.path = [];
            }

            onExited: {
                parent.hovered_edge_id = -1;
                polygonEdge.path = [];
            }
        }

        CoordinatesDataModel {
            id: coordinateModel
        }

        MapItemView {
            id: overlayView
            model: coordinateModel
            delegate: PolygonVertex {
                id: vertexDelegate
                map: osmMap
                Component.onCompleted: {
                    deleteRequested.connect(overlayView.deleteVertex)
                }
            }

            Component.onCompleted: {
                coordinateModel.dataChanged.connect(updatePolygon);
            }

            function updatePolygon() {
                let coords = [];
                for(let i = 0; i < coordinateModel.rowCount(); i++) {
                    coords.push(coordinateModel.data(coordinateModel.index(i, 0)));
                }
                if(coords.length > 2)
                    polygon.path = coords;
                else
                    polygon.path = [];
            }

            function deleteVertex(index) {
                coordinateModel.removeRow(index)
                updatePolygon();
            }
        }
    }
}
