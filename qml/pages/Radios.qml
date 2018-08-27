import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils

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
                            stations.append({
                                                "categoryTitle": raw[i].title,
                                                "radioTitle": Utils.replaceEntity(radios[j].name),
                                                "radioLogoImage": radios[j].logo,
                                                "radioDescription": Utils.replaceEntity(radios[j].description),
                                                "streamInfo": radios[j].artwork,
                                                "radioStream": streams
                                            })
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

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height + Theme.paddingLarge
        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        //        PullDownMenu {
        //            MenuItem {
        //                text: qsTr("Settings")
        //                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
        //            }
        //        }

        Column {
            id: column
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader { title: "Radio categories" }
            ExpandingSectionGroup {
                currentIndex: 0
                Repeater {

                    model: category

                    ExpandingSection {
                        title: category.get(index).categoryTitle
                        property variant dataArr: JSON.parse(category.get(index).dict)

                        content.sourceComponent: Column {

                            Repeater {
                                id: repeater

                                model: dataArr.length
                                Column {
                                    width: parent.width
                                    ListItem {
                                        height: Theme.itemSizeMedium
                                        contentHeight: Theme.itemSizeMedium
                                        width: parent.width
                                        Image {
                                            id: logo
                                            //                        height: parent.height * 0.9
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
                                            anchors.top: logo.top
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
                                            console.log(JSON.stringify(dataArr[index].radioStream))
                                            pageStack.push(Qt.resolvedUrl("PlayerPage.qml"), {
                                                               "streamInfo": dataArr[index].streamInfo,
                                                               "streamsURL": dataArr[index].radioStream,
                                                               "radioTitle": dataArr[index].radioTitle,
                                                               "radioLogo": dataArr[index].radioLogoImage
                                                           })
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

