import QtQuick 2.6
import Sailfish.Silica 1.0

ListItem {

    property alias radioLogo: logo.source
    property alias radioTitle: title.text
    property alias radioDescription: description.text

    contentHeight: Theme.itemSizeMedium
    width: parent.width
    Image {
        id: logo

        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingLarge
        anchors.verticalCenter: parent.verticalCenter
        height: Theme.itemSizeMedium
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
        truncationMode: TruncationMode.Fade
    }
    Label {
        id: description

        anchors.left: logo.right
        anchors.leftMargin: Theme.paddingLarge
        anchors.right: parent.right
        anchors.rightMargin: Theme.paddingLarge
        anchors.top: title.bottom
        truncationMode: TruncationMode.Fade
    }
}
