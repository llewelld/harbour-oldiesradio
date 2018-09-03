import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    PageHeader {
        id: header

        title: "About"
    }
    Column {
        id: content

        anchors.top: header.bottom
        width: parent.width
        spacing: Theme.paddingMedium
        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Theme.horizontalPageMargin
            width: parent.width
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignJustify
            text: "<a href='http://www.abradio.cz'>Abradio</a> - Czech Republic - Listen to free internet radio, sports, music, news, talk and podcasts."

            onLinkActivated: {
                Qt.openUrlExternally(link)
            }
        }
        Label {
            anchors.margins: Theme.horizontalPageMargin
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "Source code: <a href='https://github.com/anenash/harbour-oldiesradio'>github</a>"

            onLinkActivated: {
                Qt.openUrlExternally(link)
            }
        }
        Separator {
            width: parent.width
        }
        TextArea {
            anchors.margins: Theme.horizontalPageMargin
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "All donations will go for the purchase of the Sailfish device."
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Donate"
            onClicked: {
                Qt.openUrlExternally("https://www.paypal.me/anenash")
            }
        }
    }
}
