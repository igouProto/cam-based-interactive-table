import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Timeline 1.0
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.14

Window {
    id: window
    width: 1920
    height: 1080
    visible: true
    visibility: 'Windowed'
    title: qsTr("Interactive Table 17086108D")

    property var json_data;
    property var parsed_json;
    property bool currently_recognized: false;
    property var database; //read the product database


    Text {
        id: backendPrompt
        x: 0
        y: 0
        width: 661
        height: 109
        text: "Backend is not yet ready!\nRun 'Backend.py' and complete the camera setup process!"
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        font.family: "Avenir"
        textFormat: Text.AutoText

        Button {
            id: fullscreenToggle
            x: 255
            y: 134
            visible: false;
            text: qsTr("START")
            font.pointSize: 18
            font.family: "Avenir"
            onClicked: {
                console.log('Switching to full screen, UI running...');
                console.log(window.visibility);
                window.visibility = "FullScreen";
                backendPrompt.visible = false;
                console.log('Allowing incoming recognition results from the backend...')
                periodic_poller.running = true;
            }
        }
    }

    Connections{target: backend}

    Rectangle {
        id: startupLogo
        x: 860
        y: 440
        width: 200
        height: 200
        color: "#00000000"

        Image {
            id: polyLogo
            x: -252
            y: -252
            width: 705
            height: 705
            opacity: 0
            source: "assets/polyu-logo.png"
            fillMode: Image.PreserveAspectFit
        }
    }

    Rectangle {
        id: centerCircleBG
        x: 603
        y: 183
        width: 714
        height: 714
        visible: false
        radius: 375
        border.color: "#fbfbfb"
        border.width: 10
        scale: 0
    }

    Rectangle {
        id: centerCircle
        x: 603
        y: 183
        width: 714
        height: 714
        color: "#f4f4f4"
        radius: 375
        border.width: 0
        scale: 1
    }

    Rectangle {
        id: nutritionFactsCircle
        x: 34
        y: 487
        width: 492
        height: 492
        opacity: 1
        color: "#f4f4f4"
        radius: 246
        border.color: "#00000000"
        scale: 1

        Text {
            id: nutritionFactsTag
            x: 106
            y: 75
            text: qsTr("NUTRITION FACTS")
            font.letterSpacing: 4
            font.pixelSize: 25
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Medium
            font.family: "Avenir"
            maximumLineCount: 1
        }

        Text {
            id: nutritionFactsItems
            x: 106
            y: 120
            width: 175
            height: 302
            text: "Energy\nProtein\nFat\nSaturated Fat\nTrans Fat\nCarbs\nSugar\nSodium"
            anchors.verticalCenter: nutritionFactsNumbers.verticalCenter
            font.letterSpacing: 1.4
            font.pixelSize: 25
            verticalAlignment: Text.AlignVCenter
            lineHeight: 1.1
            lineHeightMode: Text.ProportionalHeight
            renderType: Text.QtRendering
            textFormat: Text.AutoText
            font.weight: Font.Medium
            font.family: "Avenir"
        }

        Text {
            id: nutritionFactsNumbers
            x: 210
            width: 175
            height: 302
            text: "190.8kcal\n5.4g\n29.0g\n17.5g\n0g\n60.0g\n59.0g\n60mg"
            anchors.top: nutritionFactsTag.bottom
            font.letterSpacing: 1.4
            font.pixelSize: 25
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            lineHeight: 1.1
            lineHeightMode: Text.ProportionalHeight
            anchors.topMargin: 10
            font.weight: Font.Medium
            textFormat: Text.AutoText
            font.family: "Avenir"
            renderType: Text.QtRendering
        }

        Image {
            id: image
            x: 75
            y: 75
            width: 343
            height: 343
            opacity: 0.5
            visible: false
            source: "assets/nutrition/placeholder.png"
            fillMode: Image.PreserveAspectFit
        }



    }

    Rectangle {
        id: qrCodeCircle
        x: 1349
        y: 739
        width: 288
        height: 288
        opacity: 1
        color: "#f4f4f4"
        radius: 144
        border.color: "#00000000"
        scale: 1

        Image {
            id: qrcode
            x: 61
            y: 80
            width: 166
            height: 166
            source: "assets/qrcode/placeholder.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: qrcodeLabel
            x: 88
            y: 36
            width: 112
            height: 38
            text: qsTr("Order Now")
            font.letterSpacing: 0.6
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Medium
            font.family: "Avenir"
        }
    }

    Rectangle {
        id: msrpCircle
        x: 1473
        y: 272
        width: 430
        height: 430
        opacity: 1
        color: "#f4f4f4"
        radius: 215
        border.color: "#00000000"
        scale: 1

        Text {
            id: msrp
            x: 166
            y: 117
            color: "#4a4a4a"
            text: qsTr("MSRP")
            font.letterSpacing: 0.3
            font.pixelSize: 36
            horizontalAlignment: Text.AlignHCenter
            font.styleName: "Medium"
            font.family: "Avenir"
            minimumPixelSize: 12
        }

        Text {
            id: price
            x: 111
            y: 157
            color: "#4a4a4a"
            text: qsTr("$59")
            font.letterSpacing: 3
            font.pixelSize: 119
            horizontalAlignment: Text.AlignHCenter
            style: Text.Normal
            font.styleName: "Medium"
            font.family: "Avenir"
        }
    }

    Rectangle {
        id: variantCircle
        x: 1263
        y: 28
        width: 288
        height: 288
        opacity: 1
        color: "#f4f4f4"
        radius: 144
        border.color: "#00000000"
        scale: 1

        Text {
            id: variantInfo
            x: 22
            y: 89
            width: 244
            height: 110
            text: qsTr("330 ML CAN 4.4% ALC")
            font.letterSpacing: 0.3
            font.pixelSize: 40
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            styleColor: "#00000000"
            font.styleName: "Medium"
            font.family: "Avenir"
        }
    }

    Rectangle {
        id: productInfo
        x: -900
        y: 15
        width: 772
        height: 300
        opacity: 1
        color: "#00000000"

        Text {
            id: maker
            text: "Placeholding & Co."
            anchors.left: parent.left
            anchors.top: parent.top
            font.letterSpacing: 1
            font.pixelSize: 28
            font.weight: Font.Medium
            font.family: "Avenir"
            anchors.topMargin: 0
            anchors.leftMargin: 0
            maximumLineCount: 1
        }

        Text {
            id: productName
            y: 0
            width: 772
            height: 137
            text: qsTr("Placeholderrrrrrr")
            anchors.left: parent.left
            anchors.top: maker.bottom
            font.letterSpacing: 0.3
            font.pixelSize: 100
            font.styleName: "Heavy"
            font.family: "Avenir"
            maximumLineCount: 0
            anchors.topMargin: 0
            anchors.leftMargin: 0
        }

        Text {
            id: desc
            width: 608
            height: 125
            color: "#747474"
            text: qsTr("UwU I'm just a placeholder description who likes to hold places. Nice to meet ya. It's kinda sad that you won't see me in the final product.")
            anchors.left: parent.left
            anchors.top: productName.bottom
            font.letterSpacing: 0.3
            font.pixelSize: 24
            wrapMode: Text.WordWrap
            font.styleName: "Book"
            font.family: "Avenir"
            maximumLineCount: 4
            anchors.topMargin: 0
            anchors.leftMargin: 0
        }
    }

    Rectangle {
        id: warning
        x: 574
        y: 883
        width: 772
        height: 137
        color: "#00000000"

        Image {
            id: warning_image
            x: 0
            y: 0
            width: 772
            height: 137
            source: "assets/warning/alcohol.png"
            fillMode: Image.Pad
        }
    }

    Timeline {
        id: transition
        animations: [
            TimelineAnimation {
                id: transitionAnimation
                loops: 1
                duration: 8000
                running: false
                to: 8000
                from: 0
            }
        ]
        enabled: true
        startFrame: 0
        endFrame: 8000

        KeyframeGroup {
            target: productInfo
            property: "y"
            Keyframe {
                value: 15
                frame: 609
            }

            Keyframe {
                value: 15
                frame: 137
            }
        }

        KeyframeGroup {
            target: productInfo
            property: "x"
            Keyframe {
                easing.bezierCurve: [0.219,1.01,0.556,1,1,1]
                value: 30
                frame: 608
            }

            Keyframe {
                easing.bezierCurve: [0.109,0.738,0.564,0.998,1,1]
                value: -900
                frame: 137
            }

            Keyframe {
                frame: 2496
                value: 30
            }

            Keyframe {
                frame: 2686
                value: -900
            }
        }

        KeyframeGroup {
            target: nutritionFactsCircle
            property: "scale"
            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
                frame: 802
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 1
                frame: 1007
            }

            Keyframe {
                value: 0
                frame: 0
            }

            Keyframe {
                frame: 2500
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 1
            }

            Keyframe {
                frame: 2700
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
            }
        }

        KeyframeGroup {
            target: variantCircle
            property: "scale"
            Keyframe {
                value: 0
                frame: 0
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
                frame: 919
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 1
                frame: 1095
            }

            Keyframe {
                frame: 2500
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 1
            }

            Keyframe {
                frame: 2700
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
            }
        }

        KeyframeGroup {
            target: msrpCircle
            property: "scale"
            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
                frame: 992
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 1
                frame: 1159
            }

            Keyframe {
                value: 0
                frame: 0
            }

            Keyframe {
                frame: 2500
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 1
            }

            Keyframe {
                frame: 2700
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
            }
        }

        KeyframeGroup {
            target: qrCodeCircle
            property: "scale"
            Keyframe {
                value: 0
                frame: 0
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
                frame: 1087
            }

            Keyframe {
                easing.bezierCurve: [0.221,0.996,0.778,1.01,1,1]
                value: 1
                frame: 1240
            }

            Keyframe {
                frame: 2700
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
            }

            Keyframe {
                frame: 2500
                easing.bezierCurve: [0.221,0.996,0.778,1.01,1,1]
                value: 1
            }
        }

        KeyframeGroup {
            target: warning
            property: "y"
            Keyframe {
                value: 1090
                frame: 0
            }

            Keyframe {
                easing.bezierCurve: [0.557,0.000516,0.443,0.994,1,1]
                value: 923
                frame: 1870
            }

            Keyframe {
                easing.bezierCurve: [0.556,0.00284,0.443,0.994,1,1]
                frame: 1449
                value: 1090.3
            }

            Keyframe {
                frame: 2500
                easing.bezierCurve: [0.557,0.000516,0.443,0.994,1,1]
                value: 923
            }

            Keyframe {
                frame: 2700
                easing.bezierCurve: [0.556,0.00284,0.443,0.994,1,1]
                value: 1090.3
            }
        }

        KeyframeGroup {
            target: nutritionFactsCircle
            property: "opacity"
            Keyframe {
                value: 0
                frame: 802
            }

            Keyframe {
                value: 1
                frame: 1007
            }

            Keyframe {
                frame: 2500
                value: 1
            }

            Keyframe {
                frame: 2700
                value: 1
            }
        }

        KeyframeGroup {
            target: variantCircle
            property: "opacity"
            Keyframe {
                value: 0
                frame: 919
            }

            Keyframe {
                value: 1
                frame: 1095
            }

            Keyframe {
                frame: 2500
                value: 1
            }

            Keyframe {
                frame: 2700
                value: 0
            }
        }

        KeyframeGroup {
            target: msrpCircle
            property: "opacity"
            Keyframe {
                value: 0
                frame: 992
            }

            Keyframe {
                value: 1
                frame: 1159
            }

            Keyframe {
                frame: 2700
                value: 0
            }

            Keyframe {
                frame: 2500
                value: 1
            }
        }

        KeyframeGroup {
            target: qrCodeCircle
            property: "opacity"
            Keyframe {
                value: 0
                frame: 1087
            }

            Keyframe {
                value: 1
                frame: 1242
            }

            Keyframe {
                frame: 2699
                value: 0
            }

            Keyframe {
                frame: 2500
                value: 1
            }
        }

        KeyframeGroup {
            target: productInfo
            property: "opacity"
            Keyframe {
                easing.bezierCurve: [0.222,0.752,0.443,0.994,1,1]
                frame: 137
                value: 0
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.752,0.443,0.994,1,1]
                frame: 608
                value: 1
            }

            Keyframe {
                frame: 2496
                easing.bezierCurve: [0.222,0.752,0.443,0.994,1,1]
                value: 1
            }

            Keyframe {
                frame: 2686
                easing.bezierCurve: [0.222,0.752,0.443,0.994,1,1]
                value: 0
            }
        }

        KeyframeGroup {
            target: centerCircle
            property: "scale"
            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                frame: 0
                value: 0
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                frame: 171
                value: 1
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.752,0.443,0.994,1,1]
                frame: 2502
                value: 1
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.752,0.443,0.994,1,1]
                frame: 2698
                value: 0
            }
        }

        KeyframeGroup {
            target: hint
            property: "opacity"
            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                frame: 3000
                value: 0
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                frame: 3300
                value: 1
            }

            Keyframe {
                frame: 0
                value: 0
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.752,0.443,0.994,1,1]
                value: 0
                frame: 4600
            }

            Keyframe {
                value: 1
                frame: 4300
            }
        }

        KeyframeGroup {
            target: hint
            property: "y"
            Keyframe {
                easing.bezierCurve: [0.222,0.752,0.443,0.994,1,1]
                frame: 3305
                value: 956
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                frame: 3000
                value: 990
            }
        }

        KeyframeGroup {
            target: centerCircleBG
            property: "visible"
            Keyframe {
                value: false
                frame: 5000
            }

            Keyframe {
                value: true
                frame: 4600
            }

            Keyframe {
                value: true
                frame: 0
            }
        }

        KeyframeGroup {
            target: centerCircleBG
            property: "scale"
            Keyframe {
                value: 1
                frame: 0
            }

            Keyframe {
                value: 1
                frame: 4600
            }

            Keyframe {
                value: 0
                frame: 5000
            }
        }

        KeyframeGroup {
            target: polyLogo
            property: "visible"
            Keyframe {
                value: true
                frame: 5000
            }

            Keyframe {
                value: false
                frame: 0
            }

            Keyframe {
                value: true
                frame: 6000
            }
        }

        KeyframeGroup {
            target: polyLogo
            property: "opacity"
            Keyframe {
                value: 0
                frame: 5000
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
                frame: 6000
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 1
                frame: 6496
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 1
                frame: 7000
            }

            Keyframe {
                easing.bezierCurve: [0.222,0.996,0.668,1.01,1,1]
                value: 0
                frame: 7500
            }
        }
    }

    Item {
        id: manager
        x: 1312
        y: 183
        width: 200
        height: 200

        Timer{
            id: initial_poller_for_tcp_connection
            interval: 1000; running: true; repeat: true;
            onTriggered: {
                console.log('Polling for TCP connection with backend...');
                console.log(backend.get_connection());
                if (typeof backend.get_connection() === 'undefined'){
                    console.log('no connection found with backend. Trying to tell it to establish one...');
                    backend.init_TCP();
                }else{
                    console.log('TCP connection with backend established!');
                    //periodic_poller.running = true;
                    backendPrompt.text = 'Connected with backend! Now put this window to the display of the table \n and set the UI to fullscreen by clicking START.'
                    fullscreenToggle.visible = true;
                    database = backend.get_json_db();
                    this.repeat = false;
                }
            }
        }

        Timer{
            id: periodic_poller
            interval: 500; running: false; repeat: true
            onTriggered: {
                json_data = backend.get_results(0);
                parsed_json = JSON.parse(json_data);

                var id = parsed_json['id'] + 1; //the index of database starts with 0 while my ID of objects starts with -1

                //debugText.text = parsed_json['recognized'] + '\n' + parsed_json['more_than_one'] + '\n' + parsed_json['id'] + '\n' + database[id]['Name'];

                if(parsed_json['more_than_one'] === true){  //display a message telling the user to keep only one object on the table, if more than one object is spotted.
                    console.log('more than one object spotted.')
                    tip.visible = true;
                    tiptext.visible = true;
                }else{  //make the message go away if there's only one object on the table again
                    tip.visible = false;
                    tiptext.visible = false;
                }


                if (currently_recognized !== parsed_json['recognized']){ // activate animation while the status of recognition changed
                    if (parsed_json['recognized'] === true){ //animate in
                        console.log('recog: false -> true');

                        if (transitionAnimation.running){
                            console.log("Handling spike in recognition...");
                            transitionAnimation.stop();
                        }

                        //change properties after recognition
                        productName.text = database[id]['Name'];
                        maker.text = database[id]['Maker'];
                        variantInfo.text = database[id]['Variant'];
                        price.text = '$' + database[id]['MSRP'];

                        desc.text = database[id]['Description'];

                        nutritionFactsNumbers.text = database[id]['Energy']+'kcal\n'+database[id]['Protein']+'g\n'+database[id]['Fat']+'g\n'+database[id]['Sat']+'g\n'+database[id]['Trans']+'g\n'+database[id]['Carb']+'g\n'+database[id]['Sugar']+'g\n'+database[id]['Sodium']+'g';

                        productName.color = database[id]['Color'];

                        nutritionFactsTag.color = database[id]['Desc_color'];
                        nutritionFactsItems.color = database[id]['Desc_color'];
                        nutritionFactsNumbers.color = database[id]['Desc_color'];
                        variantInfo.color = database[id]['Desc_color'];
                        msrp.color = database[id]['Desc_color'];
                        price.color = database[id]['Desc_color'];
                        qrcodeLabel.color = database[id]['Desc_color'];

                        msrpCircle.color = database[id]['Color'];
                        variantCircle.color = database[id]['Color'];
                        centerCircle.color = database[id]['Color'];
                        qrCodeCircle.color = database[id]['Color'];
                        nutritionFactsCircle.color = database[id]['Color'];

                        warning_image.source = database[id]['Warning'];

                        //start the animation
                        animationDelay.running = true;
                        transitionAnimation.from = 0;
                        transitionAnimation.to = 1872;
                        transitionAnimation.duration = 1872;
                        transitionAnimation.loops = 1;

                        //update UI status
                        currently_recognized = true;
                        idleTimeout.running = false;


                    }else if (parsed_json['recognized'] === false){ //animate out
                        console.log('recog: true -> false');

                        if (transitionAnimation.running){
                            console.log("Handling spike in recognition...");
                            transitionAnimation.stop();
                        }

                        //start the animation
                        animationDelay.running = true;
                        transitionAnimation.from = 2500;
                        transitionAnimation.to = 2700;
                        transitionAnimation.duration = 300;
                        transitionAnimation.loops = 1;

                        //update UI status
                        currently_recognized = false;
                        idleTimeout.running = true;
                        centerCircle.color = '#f4f4f4';
                    }
                }
            }
        }

        Timer{  //display a tip telling the user to put an object on the table if nothing is recognized in a time interval
            id: idleTimeout
            interval: 5000; running: true; repeat: false
            onTriggered: {
                console.log('idle timeout exceeded, displaying tip...');
                transitionAnimation.from = 3000;
                transitionAnimation.to = 4600;
                transitionAnimation.duration = 3200;
                transitionAnimation.loops = Animation.Infinite;
                transitionAnimation.running = true;
            }
        }

        Timer{
            id: animationDelay
            interval: 100; running: false; repeat: false
            onTriggered: {
                console.log('animation running!')
                transitionAnimation.running = true;
            }
        }


        Text {
            id: debugText
            x: 36
            y: 293
            width: 89
            height: 74
            visible: false
            text: "None (-1)"
            font.pixelSize: 32
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Text {
        id: hint
        x: 557
        y: 965
        opacity: 0
        color: "#959595"
        text: qsTr("⇧ Place a drink or a snack on the center of the circle ⇧ ")
        font.letterSpacing: 0.8
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.weight: Font.Medium
        font.family: "Avenir"
    }

    Rectangle {
        id: tip
        x: 557
        y: 903
        width: 789
        height: 177
        visible: false
        color: "#ffffff"

        Text {
            id: tiptext
            opacity: 1
            visible: true
            color: "#959595"
            text: "Please keep only one item on the table.\nRemove all items from the table and try again."
            textFormat: Text.AutoText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.letterSpacing: 0.8
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.NoWrap
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            font.family: "Avenir"
            font.weight: Font.Medium
        }
    }




}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.33}D{i:27}D{i:132}
}
##^##*/
