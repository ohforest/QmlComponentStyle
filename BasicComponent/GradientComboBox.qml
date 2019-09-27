import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Shapes 1.12
//import QtQuick.Controls.impl 2.12

//qtquickcontrols2\src\imports\controls\ComboBox.qml
//from Customizing ComboBox
T.ComboBox {
    id:control

    property color themeColor: "darkCyan"  //主题颜色
    property color indicatorColor: "white" //按钮颜色
    property color textColor: "white"      //文本主颜色
    property int showCount: 5              //最多显示的item个数
    property Gradient _lightToNormal: Gradient{
        GradientStop { position: 0.0; color: Qt.lighter(themeColor) }
        GradientStop { position: 0.6; color: themeColor }
    }
    property Gradient _normalToDark: Gradient{
        GradientStop { position: 0.2; color: themeColor }
        GradientStop { position: 0.9; color: Qt.darker(themeColor) }
    }
    property int _globalY: mapToGlobal(control.x,control.y).y
    property int _globalHeight: Screen.desktopAvailableHeight

    implicitWidth: 120
    implicitHeight: 30
    leftPadding: 5
    rightPadding: 5
    font{
        family: "SimSun"
        pixelSize: 16
    }

    //各item
    delegate: ItemDelegate {
        implicitWidth: control.implicitWidth
        implicitHeight: control.implicitHeight
        width: control.width
        contentItem: Text {
            text: modelData
            color: control.textColor
            font: control.font
            elide: Text.ElideRight
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
        }
        //highlighted: control.highlightedIndex === index
        background: Rectangle{
            gradient: (control.highlightedIndex === index)
                      ?_normalToDark
                      :_lightToNormal
        }
    }

    //图标自己画比较麻烦，还是贴图方便
    indicator: Shape {
        id: box_indicator
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: height*2-8
        height: control.height/2
        //smooth: true //平滑处理
        //antialiasing: true //反走样抗锯齿
        ShapePath {
            strokeWidth: 1
            strokeColor: indicatorColor
            fillRule: ShapePath.WindingFill
            fillColor: control.pressed ? Qt.lighter(themeColor) : themeColor
            startX: 0; startY: 4
            PathLine { x:0; y:0 }
            PathLine { x:box_indicator.width+1; y:0 } //+1补齐
            PathLine { x:box_indicator.width+1; y:4 }
            PathLine { x:0; y:4 }
            PathLine { x:box_indicator.width/2; y:box_indicator.height }
            PathLine { x:box_indicator.width; y:4 }
        }
    }
    //from Customizing ComboBox
    /*indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            onPressedChanged: canvas.requestPaint()
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = control.pressed ? "#17a81a" : "#21be2b";
            context.fill();
        }
    }*/

    //box显示item
    contentItem: Text {
        width: control.width-control.indicator.width-control.rightPadding
        leftPadding: control.leftPadding
        rightPadding: control.spacing

        text: control.displayText
        font: control.font
        color: control.textColor
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
        elide: Text.ElideRight
    }

    //box框背景
    background: Rectangle {
        implicitWidth: control.implicitWidth
        implicitHeight: control.implicitHeight
        radius: 3
        gradient: Gradient{
            GradientStop { position: 0.0; color: Qt.lighter(themeColor) }
            GradientStop { position: 0.5; color: themeColor }
            GradientStop { position: 1.0; color: Qt.lighter(themeColor) }
        }
    }

    //弹出框
    popup: Popup {
        //默认向下弹出，如果距离不够，y会自动调整（）
        y: control.height
        width: control.width
        //根据showCount来设置最多显示item个数
        implicitHeight: (control.delegateModel.count<showCount
                        ?contentItem.implicitHeight
                        :5*control.implicitHeight)+2
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            snapMode: ListView.SnapToItem //按行滚动
            //ScrollBar.horizontal: ScrollBar { visible: false }
            ScrollBar.vertical: ScrollBar { //定制滚动条
                id: box_bar
                implicitWidth: 10
                visible: (control.delegateModel.count>showCount)
                //background: Rectangle{} //这是整体的背景
                contentItem: Rectangle{
                    implicitWidth:10
                    radius: width/2
                    color: box_bar.pressed
                    ? Qt.rgba(0.6,0.6,0.6)
                    : Qt.rgba(0.6,0.6,0.6,0.5)
                }
            }
        }

        //弹出框背景（只有border显示出来了，其余部分被delegate背景遮挡）
        background: Rectangle {
            border.width: 1
            border.color: themeColor
            //color: Qt.lighter(themeColor)
            radius: 2
        }
    }
}
