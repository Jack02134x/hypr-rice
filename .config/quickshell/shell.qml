import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 40
        color: Qt.rgba(0, 0, 0, 0.6)

        // --- LEFT: System Info ---
        Row {
            anchors {
                left: parent.left
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }
            Text {
                font.family: "Noto Sans"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: "#cba6f7"
                text: "kuro@" + Quickshell.env("USER")
            }
        }

        // --- CENTER: Clock ---
        Row {
            anchors.centerIn: parent
            Text {
                id: clockText
                font.family: "Noto Sans"
                font.pixelSize: 18
                color: "#f5e0dc"
                text: Qt.formatDateTime(new Date(), "hh:mm:ss AP")

                Timer {
                    interval: 1000; running: true; repeat: true
                    onTriggered: clockText.text = Qt.formatDateTime(new Date(), "hh:mm:ss AP")
                }
            }
        }

        // --- RIGHT: Modules ---
        Row {
            anchors {
                right: parent.right
                rightMargin: 20
                verticalCenter: parent.verticalCenter
            }
            spacing: 20

            // Brightness
            Item{
                width: brightText.implicitWidth
                height: brightText.implicitHeight

                 Process { id: brightnessUp; command: ["brightnessctl", "set", "5%+"] }
                 Process { id: brightnessDown; command: ["brightnessctl", "set",  "5%-"] }
                 Process {
                   id: brightnessproc
                   command: ["sh", "-c", "brightnessctl get"]
                   running: true
                   stdout: SplitParser {
                       onRead: (data) => {
                            let maxcur = data.trim().split("\n")
                            let curbright = parseInt(maxcur)
                            let pctbright = Math.round((curbright/65535) * 100)
                            brightText.text = "Brightness: " + pctbright+ "%"
                            }
                        }
                    }
                    Text {
                        id: brightText
                        font.family: "Noto Sans"
                        font.pixelSize: 18
                        color: "#89b4fa"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onWheel: (wheel) => {
                            if (wheel.angleDelta.y > 0) brightnessUp.running = true;
                            else brightnessDown.running = true;
                            brightnessproc.running = true; // Update text immediately
                        }
                    }

                    Timer {
                        interval: 100; running: true; repeat: true
                        onTriggered: brightnessproc.running = true
                    }
            }

            // Volume Module
            Item {
                width: volText.implicitWidth
                height: volText.implicitHeight

                Process { id: pavuProc; command: ["pavucontrol"] }
                Process { id: volUp; command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "2%+"] }
                Process { id: volDown; command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "2%-"] }
                Process { id: muteToggle; command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"] }
                Process {
                    id: volProc
                    // We get the raw output and let JavaScript handle the logic
                    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
                    running: true
                    stdout: SplitParser {
                        onRead: (data) => {
                            let raw = data.trim();

                            if (raw.includes("[MUTED]")) {
                                volText.text = "VOL: MUTE";
                                volText.color = "#f38ba8"; // Red for muted
                            } else {
                                // Regex to find the decimal number (e.g., 0.45)
                                let match = raw.match(/[0-9]\.[0-9]+/);
                                if (match) {
                                    let val = Math.round(parseFloat(match[0]) * 100);
                                    volText.text = "VOL: " + val + "%";
                                    volText.color = "#89b4fa"; // Blue for active
                                }
                            }
                        }
                    }
                }

                Text {
                    id: volText
                    font.family: "Noto Sans"
                    font.pixelSize: 18
                    color: "#89b4fa"
                    text: "VOL: --%"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton) pavuProc.running = true;
                        if (mouse.button === Qt.RightButton) muteToggle.running = true;
                    }
                    onWheel: (wheel) => {
                        if (wheel.angleDelta.y > 0) volUp.running = true;
                        else volDown.running = true;
                        volProc.running = true; // Update text immediately
                    }
                }

                Timer {
                    interval: 100; running: true; repeat: true
                    onTriggered: volProc.running = true
                }
            }

            // Battery Module
            Item {
                width: batteryText.implicitWidth
                height: batteryText.implicitHeight

                Process {
                    id: batProc
                    command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
                    running: true
                    stdout: SplitParser {
                        onRead: (data) => batteryText.text = "BAT1: " + data.trim() + "%"
                    }
                }

                Text {
                    id: batteryText
                    font.family: "Noto Sans"
                    font.pixelSize: 18
                    color: {
                        let pct = parseInt(text.replace(/[^0-9]/g, ''));
                        return pct < 20 ? "#f38ba8" : "#a6e3a1";
                    }
                    text: "BAT1: --%"
                }

                Timer {
                    interval: 30000; running: true; repeat: true
                    onTriggered: batProc.running = true
                }
            }
        }
    }
}
