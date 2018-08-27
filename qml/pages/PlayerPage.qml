import QtQuick 2.6
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0

import "Utils.js" as Utils

Page {
    id: playerPage

    property string streamInfo: ""
    property variant streamsURL: []
    property string radioTitle: ""
    property string radioLogo: ""

    property bool setURLforTheFirstTime: true

    Component.onDestruction: {
        console.log("Close player")
        radioPlayer.stop()
        radioStation = "None"
    }

    Component.onCompleted: {
        radioStation = radioTitle
    }

    Timer {
        id: updateTrackInfo
        repeat: true
        interval: 15000
        onTriggered: {
            console.log("updateTrackInfo triggered")
            xmlModel.reload()
        }
    }

    XmlListModel {
        id: xmlModel
        source: streamInfo
        query: "/Response/Item"

        XmlRole { name: "artist"; query: "artist/string()" }
        XmlRole { name: "song"; query: "song/string()" }
        XmlRole { name: "image"; query: "imageItems/image_400/string()" }

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                console.log(status, get(0).artist, get(0).song, get(0).image)
                currentRadioIcon.source = get(0).image
                artistTitle.text = Utils.replaceEntity(get(0).artist)
                songTitle.text = Utils.replaceEntity(get(0).song)

//                radioLogo = get(0).image
                radioStation = radioTitle + "\n" + artistTitle.text + "\n" + songTitle.text

                if (setURLforTheFirstTime) {
                    setURLforTheFirstTime = false
//                    radioPlayer.source = streamsURL.get(0).url
                    radioPlayer.source = streamsURL[0].url
                    streamsView.currentIndex = 0
                }
            }
        }
    }

    onStreamInfoChanged: {
//        console.log(streamInfo)
        updateTrackInfo.start()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: mainColumn.height

        Column {
            id: mainColumn
            anchors.fill: parent
            spacing: Theme.paddingSmall
//            width: parent.width

            PageHeader { title: radioTitle }
            Image {
                id: currentRadioIcon
                anchors.horizontalCenter: parent.horizontalCenter
                source: radioLogo
                sourceSize.width: parent.width * 0.9
                sourceSize.height: parent.width * 0.8
            }
            Label {
                id: artistTitle
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                font.bold: true
                font.pixelSize: Theme.fontSizeLarge
                text: ""
                truncationMode: TruncationMode.Fade
                horizontalAlignment: "AlignHCenter"
            }
            Label {
                id: songTitle
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                font.bold: true
                font.pixelSize: Theme.fontSizeExtraLarge
                text: ""
                truncationMode: TruncationMode.Fade
                wrapMode: Text.WordWrap
                horizontalAlignment: "AlignHCenter"
            }
            Repeater {
                id: streamsView
                property int currentIndex: -1
                model: streamsURL.length
                width: parent.width
                height: parent.height * 0.33
                delegate: ListItem {
                    height: Theme.itemSizeSmall
                    contentHeight: Theme.itemSizeSmall
                    width: parent.width
                    IconButton {
                        id: playButton
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.paddingLarge
                        anchors.verticalCenter: parent.verticalCenter
                        icon.source: streamsView.currentIndex == index?radioPlayer.playbackState != 1?"image://theme/icon-m-play":"image://theme/icon-m-pause":"image://theme/icon-m-play"
                        width: Theme.iconSizeSmall
                        height: Theme.iconSizeSmall

                        onClicked: {
                            console.log("State", radioPlayer.playbackState)
                            streamsView.currentIndex = index
                            if (radioPlayer.playbackState === 1) {
                                radioPlayer.stop()
                            } else {
                                radioPlayer.source = streamsURL[index].url
                                radioPlayer.play()
                            }
                        }
                    }
                    Label {
                        anchors.left: playButton.right
                        anchors.leftMargin: Theme.paddingLarge
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: Theme.paddingMedium
                        font.pixelSize: Theme.fontSizeTiny
                        text: streamsURL[index].name
                        truncationMode: TruncationMode.Fade
                    }

                    onClicked: {
                        console.log("State", radioPlayer.playbackState)
                        streamsView.currentIndex = index
                        if (radioPlayer.playbackState === 1) {
                            radioPlayer.stop()
                        } else {
                            radioPlayer.source = streamsURL[index].url
                            radioPlayer.play()
                        }
                    }
                }
            }
        }
    }
}
