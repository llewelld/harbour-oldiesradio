import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils
import "../components"

Page {
    id: page

    property string baseURL: "http://www.abradio.cz"
    property string stationsURL: baseURL + "/data/s/stations.json"

    ListModel {
        id: stations
    }

    ListModel {
        id: category
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: true
        size: BusyIndicatorSize.Large
    }

    function fillData(data) {
        if(data !== "error") {
            var dict = []
            var raw = JSON.parse(data).categories
            for (var i in raw) {
                if (raw[i].radios !== undefined)  {
                    var radios = raw[i].radios
                    for (var j in radios) {
                        if (radios[j].streams !== undefined) {
                            var streams = radios[j].streams
//                            stations.append({
//                                                "categoryTitle": raw[i].title,
//                                                "radioTitle": Utils.replaceEntity(radios[j].name),
//                                                "radioLogoImage": radios[j].logo,
//                                                "radioDescription": Utils.replaceEntity(radios[j].description),
//                                                "streamInfo": radios[j].artwork,
//                                                "radioStream": streams
//                                            })
                            dict.push({
                                          "categoryTitle": raw[i].title,
                                          "radioTitle": Utils.replaceEntity(radios[j].name),
                                          "radioLogoImage": radios[j].logo,
                                          "radioDescription": Utils.replaceEntity(radios[j].description),
                                          "streamInfo": radios[j].artwork,
                                          "radioStream": streams
                                      })
                        }
                    }
                }
//                console.log(JSON.stringify(dict))
                category.append({"categoryTitle": raw[i].title, "dict": JSON.stringify(dict)})
                dict = []
            }
            busyIndicator.running = false
        }
    }

    Component.onCompleted: {
        Utils.sendHttpRequest("GET", stationsURL, fillData)
        //        xmlListModel.reload()
    }

    Drawer {
        id: drawer

        anchors.fill: parent
        dock: Dock.Bottom
        open: radioPlayer.source != ""?true:false

        background: PlayerItem {
            id: playerItem
            anchors.fill: parent
        }
        backgroundSize: 220 * Theme.pixelRatio
        SilicaListView {
            id: radioView
            anchors.fill: parent
            header: PageHeader { title: qsTr("Radio categories") }
            model: category
            delegate:  ExpandingSection {
                        title: categoryTitle
                        property variant dataArr: JSON.parse(category.get(index).dict)

                        content.sourceComponent: SilicaListView {
                                id: repeater

                                height: Theme.itemSizeMedium * dataArr.length
                                spacing: Theme.paddingSmall
                                clip: true
                                highlight: Rectangle {
                                    color: "#b1b1b1"
                                    opacity: 0.3
                                }
                                model: dataArr.length
                                delegate: ListItem {
                                        height: Theme.itemSizeMedium
                                        contentHeight: Theme.itemSizeMedium
                                        width: parent.width
                                        Image {
                                            id: logo

                                            anchors.left: parent.left
                                            anchors.leftMargin: Theme.paddingLarge
                                            anchors.verticalCenter: parent.verticalCenter
                                            source: dataArr[index].radioLogoImage
                                            fillMode: Image.PreserveAspectFit
                                        }
                                        Label {
                                            id: title
                                            anchors.left: logo.right
                                            anchors.leftMargin: Theme.paddingLarge
                                            anchors.right: parent.right
                                            anchors.rightMargin: Theme.paddingLarge
                                            anchors.top: parent.top
                                            anchors.topMargin: Theme.paddingSmall
                                            text: dataArr[index].radioTitle
                                            truncationMode: TruncationMode.Fade
                                        }
                                        Label {
                                            id: description
                                            anchors.left: logo.right
                                            anchors.leftMargin: Theme.paddingLarge
                                            anchors.right: parent.right
                                            anchors.rightMargin: Theme.paddingLarge
                                            anchors.top: title.bottom
                                            text: dataArr[index].radioDescription
                                            truncationMode: TruncationMode.Fade
                                        }

                                        onClicked: {
                                            console.log(JSON.stringify(dataArr[index]))
                                            playerItem.streamInfo = dataArr[index].streamInfo
                                            playerItem.streamsURL = dataArr[index].radioStream
                                            playerItem.radioTitle = dataArr[index].radioTitle
                                            playerItem.radioLogo = dataArr[index].radioLogoImage
                                        }
                                    }
                                }
                            }
            spacing: Theme.paddingSmall
            clip: true
            currentIndex: 0
        }
    }
}

