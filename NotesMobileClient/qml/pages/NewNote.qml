import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0


Page {

    ConfigurationValue {
        id: userid_cfg_value
        key: "/apps/NotesMobileClient/userid"
        defaultValue: -1
    }
    ConfigurationValue {
        id: host_cfg_value
        key: "/apps/NotesMobileClient/host"
        defaultValue: ""
    }

    ConfigurationValue {
        id: current_note_id
        key: "/apps/NotesMobileClient/current_note_id"
        defaultValue: -1
    }

    function add_new_note(_userid, _title, _text) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                console.log(json_resp['success'])
            }
        }
        xmlHttp.open("POST", host_cfg_value.value+"/api/add_note", true)
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8")
        var response_json = JSON.stringify({
                                           "userid": _userid,
                                           "title": _title,
                                           "text": _text
                                       });
        xmlHttp.send(response_json)
    }



    id: page
    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height



        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge


            Label {
                id: header
                text: "New Note"
                font.pixelSize: 50
                anchors.horizontalCenter: parent.horizontalCenter
            }


            TextArea {
                id: note_title
                text: "Title"
                background: Rectangle {
                    color: "black"
                    opacity: 0.2
                    width: parent.width
                    height: parent.height
                }
            }

            TextArea {
                id: note_text
                text: "Text"
                wrapMode: Text.WrapAnywhere
                background: Rectangle {
                    color: "black"
                    opacity: 0.2
                    width: parent.width
                    height: parent.height
                }

            }


            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingLarge
                id: row_controls
                Button {
                    id: bt_add_note
                    text: "Add"
                    onClicked: {
                        add_new_note(userid_cfg_value.value, note_title.text, note_text.text)
                        pageStack.animatorPush(Qt.resolvedUrl("FirstPage.qml"))
                    }
                }

                Button {
                    id: bt_to_all_notes_page
                    text: "Back"
                     onClicked: pageStack.animatorPush(Qt.resolvedUrl("FirstPage.qml"))
                }

            }
        }
    }

}
