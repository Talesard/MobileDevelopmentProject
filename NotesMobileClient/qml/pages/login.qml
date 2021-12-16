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
        id: username_cfg_value
        key: "/apps/NotesMobileClient/username"
        defaultValue: ""
    }


    function login(_login, _password){
        const xmlHttp = new XMLHttpRequest()
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                var json_resp = JSON.parse(xmlHttp.responseText)
                var tmp = "UserId\n"
                // userid_label.text = "UserId: " + json_resp['userid']
                userid_cfg_value.value = json_resp['userid']
                username_cfg_value.value = json_resp['username']
                status_label.text = "Login status: " + json_resp['success'] + ", as " + json_resp['username']
            }
        }
        xmlHttp.open("POST", host_cfg_value.value+"/api/login", true)
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8")
        var response_json = JSON.stringify({"login": _login,
                                            "password": _password,
                                           });
        xmlHttp.send(response_json)
    }

    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Notes Page")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("FirstPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge
            property var host: "http://192.168.0.105:5000"

            PageHeader {
                Label {
                    text: "Settings"
                    font.pixelSize: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Label {
                text: "LOGIN SETTINGS"
                font.pixelSize: 40
            }

            Label {
                id: status_label
                text: "Login status: " + (userid_cfg_value.value === -1 ? "false" : "true, as " + username_cfg_value.value)
            }

            TextField {
                id: login_input
                placeholderText: "login"
            }

            TextField {
                id: password_input
                placeholderText: "password"
            }

            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id: login_bt
                    text: "Login"
                    onClicked: {login(login_input.text, password_input.text)}
                }

                Button {
                    id: logout_bt
                    text: "Logout"
                    onClicked: {
                        userid_cfg_value.value = -1
                        username_cfg_value.value = ""
                    }
                }
            }


            Label {
                text: "HOST SETTINGS"
                font.pixelSize: 40
            }
            TextField {
                id: host_input
                placeholderText: "host: " + host_cfg_value.value
            }

            Button {
                id: change_host_bt
                text: "ChangeHost"
                onClicked: {host_cfg_value.value = host_input.text; host_input.placeholderText = "host: " + host_cfg_value.value}
                anchors.horizontalCenter: parent.horizontalCenter
            }


        }
    }
}
