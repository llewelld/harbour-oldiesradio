import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import "pages"

ApplicationWindow
{
    id: app

    property string radioStation: "None"
    property string radioLogo: "harbour-oldiesradio.png"
    property bool playRadio: false

    onRadioStationChanged: {
        console.log(radioStation)
    }

    onRadioLogoChanged: {
        console.log(radioLogo)
    }

    function setIcon(value) {
        return value?"image://theme/icon-cover-pause":"image://theme/icon-cover-play"
    }

    Audio {
        id: radioPlayer
        source: ""
        autoLoad: true
        autoPlay: false
        onError: {
            console.log("Error happened", radioPlayer.errorString, "error num", radioPlayer.error)
        }
        onPlaying: {
            playRadio = true
        }
        onStopped: {
            playRadio = false
        }
        onSourceChanged: {
            if(source != "") {
                play()
            }
        }
    }

    initialPage: Component { Radios { } }
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait

    cover: Component {
        CoverBackground {
            CoverPlaceholder {
                id: coverItem
                text: app.radioStation
                icon.source: app.radioLogo
                icon.width: 128
                icon.height: 128
            }

            CoverActionList {
                id: coverAction
                enabled: true
                CoverAction {                    
                    iconSource: app.setIcon(playRadio)
                    onTriggered: {
                        if(radioPlayer.source != "") {
                            if(playRadio) {
                                radioPlayer.stop()
                            } else {
                                radioPlayer.play()
                            }
                        }
                    }
                }
            }
        }
    }
}

