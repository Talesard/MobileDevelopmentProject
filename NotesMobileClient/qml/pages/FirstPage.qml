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


    function get_all_notes(_userid) {
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                for (var i = 0; i < json_resp['notes'].length; i++) {
                    var _title = json_resp['notes'][i]['title']
                    var _text = json_resp['notes'][i]['text']
                    var _date = json_resp['notes'][i]['date']
                    var _id = json_resp['notes'][i]['id']
                    notes_model.append({date: _date, title: _title, text: _text, id: _id})
                }
            }
        }
        xmlHttp.open("POST", host_cfg_value.value+"/api/get_all_notes", true)
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8")
        var response_json = JSON.stringify({"userid": _userid});
        xmlHttp.send(response_json)
    }

    id: page

    allowedOrientations: Orientation.All

    ListModel {
        id: notes_model
    }

    SilicaListView {
        id: listView
        model: notes_model
        anchors.fill: parent
        spacing: Theme.paddingLarge

        header: PageHeader {
            title: qsTr("")
        }

        Button {
            id: new_note_bt
            x: Theme.paddingLarge
            y: Theme.paddingLarge
            text: "Add New"
            onClicked: {
                pageStack.animatorPush(Qt.resolvedUrl("NewNote.qml"))
            }
        }

        Button {
            id: settings_bt
            y: Theme.paddingLarge
            x: new_note_bt.x + new_note_bt.width + Theme.paddingLarge
            text: "Settings"
            onClicked: {
                pageStack.animatorPush(Qt.resolvedUrl("Settings.qml"))
            }
        }

        delegate: BackgroundItem {
            id: delegate

            Label {
                x: Theme.horizontalPageMargin
                text: title + "\n" + date
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: {
                console.log("Clicked note id: " + id)
                current_note_id.value = id
                console.log("Current note id cfg: " + current_note_id.value)
                pageStack.animatorPush(Qt.resolvedUrl("NoteDetails.qml"))
            }
        }
        VerticalScrollDecorator {}
    }

    Timer {
        id: timer
        interval: 60000
        repeat: true
        running:true
        onTriggered:  {
            notes_model.clear();
            get_all_notes(userid_cfg_value.value)
        }
    }

    Component.onCompleted: {get_all_notes(userid_cfg_value.value)}
}
