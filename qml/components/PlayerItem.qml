import QtQuick 2.6
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0

import "../pages/Utils.js" as Utils

Item {
    id: playerControl

    property string streamInfo: ""
    property variant streamsURL: []
    property string radioTitle: ""
    property string radioLogo: ""

    property bool setURLforTheFirstTime: true


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
                currentRadioLogo.source = get(0).image
                artistTitle.text = Utils.replaceEntity(get(0).artist)
                songTitle.text = Utils.replaceEntity(get(0).song)

//                radioLogo = get(0).image
                radioStation = radioTitle + "\n" + artistTitle.text + "\n" + songTitle.text

                if (setURLforTheFirstTime) {
                    setURLforTheFirstTime = false
//                    radioPlayer.source = streamsURL.get(0).url
                    radioPlayer.source = streamsURL[0].url
//                    streamsView.currentIndex = 0
                }
            }
        }
    }

    Image {
        id: currentRadioLogo
        height: 200 * Theme.pixelRatio
        width: 200 * Theme.pixelRatio
        fillMode: Image.PreserveAspectFit
        source: radioLogo
        onStatusChanged: {
            if(status === Image.Error) {
                console.log("Can not load image")
                source = radioLogo
            }
        }
        onSourceChanged: {
            console.log("load image", source)
            update()
        }
    }
    Label {
        id: currentStationName
        anchors.left: currentRadioLogo.right
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.top: currentRadioLogo.top
        font.pixelSize: Theme.fontSizeExtraSmall
        text:  radioTitle
    }
    Text {
        id: artistTitle
        anchors.left: currentStationName.left
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.top: currentStationName.bottom
        anchors.topMargin: Theme.paddingSmall
        font.pixelSize: Theme.fontSizeExtraSmall
    }
    Text {
        id: songTitle
        anchors.left: currentStationName.left
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.top: artistTitle.bottom
        anchors.topMargin: Theme.paddingSmall
        font.pixelSize: Theme.fontSizeExtraSmall
    }

    IconButton {
        id: playButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: Theme.paddingLarge
//        anchors.verticalCenter: parent.verticalCenter
//        anchors.verticalCenterOffset: 20 * Theme.pixelRatio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30 * Theme.pixelRatio
        z: 3
        icon.source: radioPlayer.playbackState != 1?"image://theme/icon-l-play":"image://theme/icon-l-pause"
        width: 50 * Theme.pixelRatio
        height: 50 * Theme.pixelRatio
        onClicked: {
            console.log("State", radioPlayer.playbackState)
            if (radioPlayer.playbackState === 1) {
                radioPlayer.stop()
                app.coverButtonIcon = "image://theme/icon-cover-play"
//                updateSlider.stop()
            } else {
                radioPlayer.play()
                app.coverButtonIcon = "image://theme/icon-cover-pause"
//                if(showFullControl && app.player.seekable) {
//                    updateSlider.start()
//                }
            }
        }
    }

    ValueButton {
        id: sreamBitrateLabel

        anchors.right: parent.right
        anchors.rightMargin: 10 * Theme.pixelRatio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * Theme.pixelRatio
        width: parent.width * 0.3

        onClicked: {
            var dialog = pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))

            dialog.accepted.connect(function() {
                console.log("New bitrate", dialog.rate)
                value = dialog.rate
                bitrateQuality(value)
            })
        }
    }
}
