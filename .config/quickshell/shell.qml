import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

ShellRoot {
    id: root

    property bool launcherOpen: false
    property string query: ""
    property var applicationEntries: []
    property string wallpaperDirectory: "/home/jack/wallpapers/static_unsorted_wallpapers"
    property string livewallpaperDirectory: "/home/jack/wallpapers/VideoWallpapers"
    property var wallpapers: []
    property bool wallpaperPickerActive: false
    property string launcherMode: {
        if (query.startsWith("$"))
            return "command"
        if (query.startsWith("#"))
            return "web"
        if (/^c\s+/i.test(query))
            return "calculate"
        if (/^w\s+/i.test(query))
            return "wallpaper"
        return "application"
    }
    property var filteredApplications: launcherMode === "application"
        ? applicationEntries.filter(entry => matches(entry)) : []
    property string calculation: launcherMode === "calculate"
        ? calculate(query.slice(1).trim()) : ""
    property var filteredWallpapers: launcherMode === "wallpaper"
        ? wallpapers.filter(path => wallpaperFileName(path).toLowerCase().includes(query.slice(1).trim().toLowerCase())) : []
    property var filteredLiveWallpapers: launcherMode === "livewallpaper"
        ? wallpapers.filter(path => wallpaperFileName(path).toLowerCase().includes(query.slice(1).trim().toLowerCase())) : []

    Style {
        id: style
    }

    function matches(entry) {
        if (!entry)
            return false

        const needle = query.trim().toLowerCase()
        if (needle.length === 0)
            return !entry.noDisplay

        return !entry.noDisplay && (
            entry.name.toLowerCase().includes(needle)
            || entry.genericName.toLowerCase().includes(needle)
            || entry.comment.toLowerCase().includes(needle)
            || entry.keywords.join(" ").toLowerCase().includes(needle)
        )
    }

    function selectMatch(start, direction) {
        if (appList.count === 0)
            return

        let index = start < 0 ? (direction > 0 ? -1 : 0) : start
        for (let attempt = 0; attempt < appList.count; ++attempt) {
            index = (index + direction + appList.count) % appList.count
            appList.currentIndex = index
            appList.positionViewAtIndex(index, ListView.Contain)
            return
        }
    }

    function selectFirstMatch() {
        if (appList.count > 0) {
            appList.currentIndex = 0
            appList.positionViewAtIndex(0, ListView.Beginning)
        } else {
            appList.currentIndex = -1
        }
    }

    function launchSelected() {
        if (appList.currentItem && appList.currentItem.appEntry)
            appList.currentItem.appEntry.execute()
        closeLauncher()
    }

    function submitQuery() {
        const value = query.trim()

        if (launcherMode === "command") {
            const command = value.slice(1).trim()
            if (command.length > 0) {
                Quickshell.execDetached(["sh", "-c", command])
                closeLauncher()
            }
        } else if (launcherMode === "web") {
            const search = value.slice(1).trim()
            if (search.length > 0) {
                const hasScheme = /^https?:\/\//i.test(search)
                const looksLikeUrl = hasScheme || /^[^\s/]+\.[^\s]+(?:\/\S*)?$/.test(search)
                const destination = hasScheme ? search : looksLikeUrl ? "https://" + search
                    : "https://www.google.com/search?q=" + encodeURIComponent(search)
                Quickshell.execDetached([
                    "firefox",
                    destination
                ])
                closeLauncher()
            }
        } else if (launcherMode === "application") {
            launchSelected()
        } else if (launcherMode === "wallpaper" && wallpaperGrid.currentIndex >= 0) {
            applyWallpaper(filteredWallpapers[wallpaperGrid.currentIndex])
        }
    }

    function wallpaperFileName(path) {
        return path.slice(path.lastIndexOf("/") + 1).replace(/\.[^.]+$/, "")
    }

    function loadWallpapers() {
        if (!wallpaperListProcess.running)
            wallpaperListProcess.running = true
    }

    function applyWallpaper(path) {
        Quickshell.execDetached([
            "sh", "-c",
            "awww img \"$1\" --transition-type random; "
                + "matugen image \"$1\" --source-color-index 0; "
                + "echo \"$2\" > \"$3\"; cp -- \"$1\" \"$4\"",
            "wallpaper-apply",
            path,
            wallpaperFileName(path),
            "/home/jack/.scripts/wallname.txt",
            "/home/jack/wallpapers/wall"
        ])
        closeLauncher()
    }

    function selectWallpaper(start, direction) {
        if (wallpaperGrid.count === 0)
            return

        const index = start < 0
            ? (direction > 0 ? 0 : wallpaperGrid.count - 1)
            : (start + direction + wallpaperGrid.count) % wallpaperGrid.count
        wallpaperGrid.currentIndex = index
        wallpaperGrid.positionViewAtIndex(index, GridView.Contain)
    }

    function calculate(expression) {
        let input = expression.replace(/\s+/g, "")
        let position = 0

        function fail() {
            throw new Error("Invalid expression")
        }

        function primary() {
            if (input[position] === "(") {
                ++position
                const value = sum()
                if (input[position] !== ")")
                    fail()
                ++position
                return value
            }

            const match = input.slice(position).match(/^(?:\d+(?:\.\d*)?|\.\d+)/)
            if (!match)
                fail()
            position += match[0].length
            return Number(match[0])
        }

        function power() {
            let value = primary()
            if (input[position] === "^") {
                ++position
                value = Math.pow(value, unary())
            }
            return value
        }

        function unary() {
            if (input[position] === "+") {
                ++position
                return unary()
            }
            if (input[position] === "-") {
                ++position
                return -unary()
            }
            return power()
        }

        function product() {
            let value = unary()
            while ("*/%".includes(input[position])) {
                const operator = input[position++]
                const right = unary()
                if (operator === "*") value *= right
                else if (operator === "/") value /= right
                else value %= right
            }
            return value
        }

        function sum() {
            let value = product()
            while ("+-".includes(input[position])) {
                const operator = input[position++]
                const right = product()
                value = operator === "+" ? value + right : value - right
            }
            return value
        }

        try {
            if (input.length === 0)
                return "Enter an expression"
            const result = sum()
            if (position !== input.length || !Number.isFinite(result))
                return "Invalid expression"
            return "= " + Number(result.toPrecision(12)).toString()
        } catch (error) {
            return "Invalid expression"
        }
    }

    function openLauncher() {
        launcherOpen = true
        query = ""
        searchField.text = ""
        selectFirstMatch()
        searchField.forceActiveFocus()
    }

    function closeLauncher() {
        launcherOpen = false
        query = ""
        searchField.text = ""
    }

    IpcHandler {
        target: "launcher"

        function open() { root.openLauncher() }
        function close() { root.closeLauncher() }
        function toggle() {
            if (root.launcherOpen)
                root.closeLauncher()
            else
                root.openLauncher()
        }
    }

    // DesktopEntries is an UntypedObjectModel. Instantiator gives us its items
    // as normal QML objects, allowing a filtered JavaScript array for ListView.
    Instantiator {
        model: DesktopEntries.applications

        delegate: QtObject {
            required property var modelData
            property var appEntry: modelData
        }

        onObjectAdded: function(index, object) {
            const entries = root.applicationEntries.slice()
            entries.splice(index, 0, object.appEntry)
            root.applicationEntries = entries
        }

        onObjectRemoved: function(index) {
            const entries = root.applicationEntries.slice()
            entries.splice(index, 1)
            root.applicationEntries = entries
        }
    }

    Process {
        id: wallpaperListProcess
        command: [
            "find", root.wallpaperDirectory, "-maxdepth", "1", "-type", "f", "(",
            "-iname", "*.png", "-o", "-iname", "*.jpg", "-o", "-iname", "*.jpeg", "-o",
            "-iname", "*.webp", "-o", "-iname", "*.gif", ")", "-printf", "%p\\n"
        ]

        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                root.wallpapers = text.split("\n").filter(path => path.length > 0)
            }
        }
    }

    PanelWindow {
        id: launcherWindow
        visible: root.launcherOpen
        color: "transparent"
        focusable: true
        aboveWindows: true
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Rectangle {
            anchors.fill: parent
            color: style.scrim

            MouseArea {
                anchors.fill: parent
                onClicked: root.closeLauncher()
            }
        }

        Rectangle {
            id: launcher
            width: 660
            height: root.launcherMode === "wallpaper" ? 680
                : Math.min(620, Math.max(270, appList.contentHeight + 118))
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Math.max(64, parent.height * 0.14)
            radius: style.cornerRadius
            color: style.surface
            border.width: 1
            border.color: style.border
            clip: true

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    root.closeLauncher()
                    event.accepted = true
                } else if (event.key === Qt.Key_Down) {
                    if (root.launcherMode === "wallpaper")
                        root.selectWallpaper(wallpaperGrid.currentIndex, 1)
                    else
                        root.selectMatch(appList.currentIndex, 1)
                    event.accepted = true
                } else if (event.key === Qt.Key_Up) {
                    if (root.launcherMode === "wallpaper")
                        root.selectWallpaper(wallpaperGrid.currentIndex, -1)
                    else
                        root.selectMatch(appList.currentIndex, -1)
                    event.accepted = true
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: style.outerMargin
                spacing: 10

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 46
                    focus: true
                    placeholderText: "Search applications"
                    font.pixelSize: 18
                    color: style.text
                    leftPadding: 16
                    rightPadding: 16
                    selectByMouse: true

                    background: Rectangle {
                        radius: style.cornerRadius - 3
                        color: style.input
                        border.width: 1
                        border.color: searchField.activeFocus ? style.borderFocused : style.border
                    }

                    onTextChanged: {
                        root.query = text
                        if (root.launcherMode === "wallpaper" && !root.wallpaperPickerActive) {
                            root.wallpaperPickerActive = true
                            root.loadWallpapers()
                        } else if (root.launcherMode !== "wallpaper") {
                            root.wallpaperPickerActive = false
                        }
                        root.selectFirstMatch()
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Escape) {
                            root.closeLauncher()
                            event.accepted = true
                        } else if (event.key === Qt.Key_Down) {
                            if (root.launcherMode === "wallpaper")
                                root.selectWallpaper(wallpaperGrid.currentIndex, 1)
                            else
                                root.selectMatch(appList.currentIndex, 1)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Up) {
                            if (root.launcherMode === "wallpaper")
                                root.selectWallpaper(wallpaperGrid.currentIndex, -1)
                            else
                                root.selectMatch(appList.currentIndex, -1)
                            event.accepted = true
                        }
                    }

                    onAccepted: root.submitQuery()
                }

                ListView {
                    id: appList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 3
                    model: root.filteredApplications
                    currentIndex: -1
                    keyNavigationEnabled: false
                    visible: root.launcherMode === "application"

                    onCountChanged: {
                        if (root.launcherOpen)
                            root.selectFirstMatch()
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    delegate: Item {
                        id: appDelegate
                        required property var modelData
                        required property int index
                        property var appEntry: modelData
                        readonly property bool selected: ListView.isCurrentItem

                        width: ListView.view.width
                        height: style.rowHeight

                        Rectangle {
                            anchors.fill: parent
                            radius: style.cornerRadius - 3
                            color: appDelegate.selected ? style.selection : appMouse.containsMouse ? style.surfaceHover : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                spacing: 12

                                IconImage {
                                    Layout.preferredWidth: 30
                                    Layout.preferredHeight: 30
                                    source: Quickshell.iconPath(appDelegate.appEntry.icon, "application-x-executable")
                                    implicitSize: 30
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        Layout.fillWidth: true
                                        text: appDelegate.appEntry.name
                                        color: style.text
                                        font.pixelSize: 15
                                        font.weight: Font.DemiBold
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: appDelegate.appEntry.genericName || appDelegate.appEntry.comment
                                        color: style.textMuted
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                        visible: text.length > 0
                                    }
                                }
                            }

                            MouseArea {
                                id: appMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    appList.currentIndex = appDelegate.index
                                    root.launchSelected()
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: appList.count > 0 && appList.currentIndex === -1
                        text: "No matching applications"
                        color: style.textMuted
                        font.pixelSize: 14
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: root.launcherMode !== "application" && root.launcherMode !== "wallpaper"
                    radius: style.cornerRadius - 3
                    color: style.surfaceRaised
                    border.width: 1
                    border.color: style.border

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 18
                        spacing: 8

                        Text {
                            Layout.fillWidth: true
                            text: root.launcherMode === "command" ? "Run command"
                                : root.launcherMode === "web" ? "Search Firefox"
                                : "Calculator"
                            color: style.textMuted
                            font.pixelSize: 13
                        }

                        Text {
                            Layout.fillWidth: true
                            text: root.launcherMode === "calculate" ? root.calculation
                                : root.launcherMode === "command" ? "Press Enter to run this command"
                                : "Press Enter to search the web"
                            color: style.text
                            font.pixelSize: root.launcherMode === "calculate" ? 24 : 16
                            font.weight: root.launcherMode === "calculate" ? Font.DemiBold : Font.Normal
                            wrapMode: Text.Wrap
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: root.launcherMode === "wallpaper"

                    GridView {
                        id: wallpaperGrid
                        anchors.fill: parent
                        clip: true
                        cellWidth: 202
                        cellHeight: 152
                        model: root.filteredWallpapers
                        currentIndex: -1

                        onCountChanged: {
                            if (root.launcherMode === "wallpaper")
                                root.selectFirstWallpaper()
                        }

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: Item {
                            id: wallpaperDelegate
                            required property string modelData
                            required property int index
                            readonly property bool selected: GridView.isCurrentItem

                            width: wallpaperGrid.cellWidth
                            height: wallpaperGrid.cellHeight

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: 4
                                radius: style.cornerRadius - 3
                                color: wallpaperDelegate.selected ? style.selection
                                    : wallpaperMouse.containsMouse ? style.surfaceHover : style.surfaceRaised
                                border.width: 1
                                border.color: wallpaperDelegate.selected || wallpaperMouse.containsMouse
                                    ? style.borderFocused : style.border
                                clip: true

                                Image {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    height: 100
                                    source: wallpaperDelegate.modelData
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    cache: false
                                }

                                Text {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 9
                                    text: root.wallpaperFileName(wallpaperDelegate.modelData)
                                    color: style.text
                                    font.pixelSize: 12
                                    elide: Text.ElideRight
                                }

                                MouseArea {
                                    id: wallpaperMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: root.applyWallpaper(wallpaperDelegate.modelData)
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: !wallpaperListProcess.running && root.filteredWallpapers.length === 0
                        text: "No matching wallpapers"
                        color: style.textMuted
                        font.pixelSize: 14
                    }
                }
            }
        }

        Component.onCompleted: root.closeLauncher()
    }
}
