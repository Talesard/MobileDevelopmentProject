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

    function get_note_by_id(_userid, _note_id) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                var title = json_resp['title']
                var text = json_resp['text']
                var date = json_resp['date']
                var id = json_resp['id']
                note_date.text = date
                note_title.text = title
                note_text.text = text
            }
        }
        xmlHttp.open("POST", host_cfg_value.value+"/api/get_one_note_by_id", true)
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8")
        var response_json = JSON.stringify({"userid": _userid, "note_id": _note_id});
        xmlHttp.send(response_json)
    }

    function edit_note(_userid, _note_id, _title, _text) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                console.log(json_resp['success'])
            }
        }
        xmlHttp.open("POST", host_cfg_value.value+"/api/edit_note", true)
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8")
        var response_json = JSON.stringify({
                                           "userid": _userid,
                                           "title": _title,
                                           "text": _text,
                                           "note_id": _note_id
                                       });
        xmlHttp.send(response_json)
    }

    function delete_note(_userid, _note_id) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                console.log(json_resp['success'])
            }
        }
        xmlHttp.open("POST", host_cfg_value.value+"/api/del_note", true)
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8")
        var response_json = JSON.stringify({
                                           "userid": _userid,
                                           "note_id": _note_id
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
                text: "Note Details"
                font.pixelSize: 50
                anchors.horizontalCenter: parent.horizontalCenter
            }


                Label {
                    id: note_date
                    text: "note_date"
                    anchors.horizontalCenter: parent.horizontalCenter
                }


            TextArea {
                id: note_title
                text: "note title"
                background: Rectangle {
                    color: "black"
                    opacity: 0.2
                    width: parent.width
                    height: parent.height
                }
            }

            TextArea {
                id: note_text
                text: "note_text"
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
                    id: bt_save_changes
                    text: "Save Changes"
                    onClicked: {
                        edit_note(userid_cfg_value.value, current_note_id.value, note_title.text, note_text.text)
                    }
                }

                Button {
                    id: delete_note_bt
                    text: "Delete Note"
                    onClicked: {
                        delete_note(userid_cfg_value.value, current_note_id.value)
                        pageStack.animatorPush(Qt.resolvedUrl("FirstPage.qml"))
                    }
                }
            }

            Button {
                id: bt_to_all_notes_page
                anchors.horizontalCenter: row_controls.horizontalCenter
                text: "Back"
                 onClicked: pageStack.animatorPush(Qt.resolvedUrl("FirstPage.qml"))
            }
        }
    }

    Component.onCompleted: {get_note_by_id(userid_cfg_value.value, current_note_id.value)}
}
