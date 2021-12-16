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

    function get_all_notes(_userid) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                var tmp = ""
                for (var i = 0; i < json_resp['notes'].length; i++) {
                    var title = json_resp['notes'][i]['title']
                    var text = json_resp['notes'][i]['text']
                    var date = json_resp['notes'][i]['date']
                    var id = json_resp['notes'][i]['id']
                    tmp += "Date: " + date + '\n' + "Title: " + title  + '\n' + "Text: " + text + '\n' + "Id: " + id + '\n\n'
                }
                clear_all_fields()
                notes.text = tmp
            }
        }
        xmlHttp.open("POST", host_cfg_value.value+"/api/get_all_notes", true)
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8")
        var response_json = JSON.stringify({"userid": _userid});
        xmlHttp.send(response_json)
    }

    function add_new_note(_userid, _title, _text) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                console.log(json_resp['success'])
                clear_all_fields()
                if (json_resp['success'] === true) {get_all_notes(userid_cfg_value.value)}
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

    function delete_note(_userid, _note_id) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                console.log(json_resp['success'])
                clear_all_fields()
                if (json_resp['success'] === true) {get_all_notes(userid_cfg_value.value)}
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

    function edit_note(_userid, _note_id, _title, _text) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                console.log(json_resp['success'])
                clear_all_fields()
                if (json_resp['success'] === true) {get_all_notes(userid_cfg_value.value)}
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

    function clear_all_fields() {
        title_input.text = ""
        text_input.text = ""
        id_del_edit_input.text = ""
    }

    id: page
    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Settings Page")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("login.qml"))
            }
        }
        contentHeight: column.height



        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge

            TextField {
                id: title_input
                placeholderText: "note title"
            }

            TextArea {
                id: text_input
                placeholderText: "note text"
            }

            TextField {
                id: id_del_edit_input
                placeholderText: "del/edit id"
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge
                Button {
                    id: add_bt
                    text: "Add Note"
                    //anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        add_new_note(userid_cfg_value.value, title_input.text, text_input.text)
                    }
                }

                Button {
                    id: get_all_bt
                    text: "Refresh"
                    //anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        get_all_notes(userid_cfg_value.value)
                    }
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge
                Button {
                    id: delete_bt
                    text: "Delete"
                    //anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        delete_note(userid_cfg_value.value, id_del_edit_input.text)
                    }
                }

                Button {
                    id: edit_bt
                    text: "Edit"
                    //anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        edit_note(userid_cfg_value.value, id_del_edit_input.text, title_input.text, text_input.text)
                    }
                }
            }


            TextArea {
                id: notes
                text: ""
                wrapMode: Text.WrapAnywhere
                readOnly: true
            }

        }
    }
    Component.onCompleted: {get_all_notes(userid_cfg_value.value)}
}
