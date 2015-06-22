/****************************************************************************
** Konica Minolta
** Artem Avtandilov
** 22/06/2015
** Main interface file. sDescribes all interface features. JS in QML
****************************************************************************/

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import SortFilter 1.0
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs 1.2
import Messager 1.0


ApplicationWindow {
    id: window
    visible: true
    title: "Konica Minolta Kunden Dateibank"
    signal supersignal()
    signal setAllCheckboxes()
    property bool pdfButtonEnabled: true
    style: ApplicationWindowStyle {
        background: Rectangle{

            anchors.fill: parent
        }
    }

    FileDialog {
        id: fileDialog
        visible: false
        title: "PDF-Datei auswählen"
        nameFilters: [ "PDF-Datei (*.pdf)" ]
        selectedNameFilter: "All files (*)"
        onAccepted: {
            console.log("Accepted: " + fileDialog.fileUrls)
                pdfButton.enabled = false
                xmlButton.enabled = true
                pdfButtonEnabled = false
            console.log("Accepted: " + pdfButtonEnabled)
        }
        onRejected: { console.log("Rejected") }
    }



    function append(newElement)
    {
    sourceModel.append(newElement)
    }



    toolBar: ToolBar {
        height: 45
        style: ToolBarStyle
        {
        background:
            Rectangle
            {
            color: "white"
    }}
        Image{
            id: pic
            source: "pics/konica.png"
                }


        Button {
            text: "          PDF wählen"
            id: pdfButton
           // iconSource: "qrc:/pics/pdf.png"
           // width: 40
            height: 35


            anchors.left: pic.right
            anchors.margins: 20

            anchors.verticalCenter: parent.verticalCenter
            enabled: pdfButtonEnabled

            Image {
                x: 5
                y: 5
                source: "qrc:/pics/pdf.png"
                height: 25
                width: 25
            }




            onClicked:
            {
                fileDialog.open();

            }
        }

Button {
    text: "          Exportieren"
    id: xmlButton
    anchors.left: pdfButton.right
    anchors.margins: 10
    anchors.verticalCenter: parent.verticalCenter
    enabled: !pdfButtonEnabled
    height: 35


    Image {
        x: 5
        y: 5
        source: "qrc:/pics/xml.png"
        height: 25
        width: 25
    }

    Message
    {
        signal xmlActivated()
        id: message

     onEntryChanged:    {
         console.log("entry Changed")
         pdfButton.enabled = true
         xmlButton.enabled = false
         }
     onXmlActivated: {
         //entry = { URL: fileDialog.fileUrls.toString()}
         entry = { URL: fileDialog.fileUrls.toString()}  // invokes Message::setentry()
         for (var i=0; i<sourceModel.count; i++)
         {
             if(sourceModel.get(i).bool)
             {
             var schicken= {idnumber: sourceModel.get(i).idnumber,
                     name: sourceModel.get(i).name,
                     zip:sourceModel.get(i).zip,
                     city:sourceModel.get(i).city,
                     country: sourceModel.get(i).country,
                     street: sourceModel.get(i).street}
             entry= schicken
             }
         }



         console.log (entry) //invokes XML open dialog




     }


    }
    onClicked: message.xmlActivated()






}
        TextField {
            id: searchBox

            placeholderText: "Suchen..."
            inputMethodHints: Qt.ImhNoPredictiveText

            width: window.width / 5 * 2

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    TableView {
        id: tableView
        frameVisible: false
        sortIndicatorVisible: true
        sortIndicatorColumn: 2
        selectionMode: SelectionMode.NoSelection
        anchors.fill: parent
        anchors.margins: 10
        Layout.minimumWidth: 400
        Layout.minimumHeight: 240
        Layout.preferredWidth: 800
        Layout.preferredHeight: 600
        alternatingRowColors: true


    FocusScope {
        id: checkboxAllscope

        Accessible.role: Accessible.CheckBox

        property string text: ""
        property bool checked // required variable

        width: 20
        height: 20

        CheckBox
        {
            id: checkboxAll
            width: 20
            height: 20
            signal setAllCheckboxesLocal()
            property bool selectedAll: true
            onClicked:
            {
                for (var i=0; i<sourceModel.count; i++)
                sourceModel.set(i, {"bool": selectedAll})
                checkboxAll.checkedState = selectedAll ? Qt.Checked : Qt.Unchecked
                selectedAll = !selectedAll
                supersignal()

            }

            Component.onCompleted: window.setAllCheckboxes.connect(setAllCheckboxesLocal)
            property bool firstValue: true
            onSetAllCheckboxesLocal:
            {
                firstValue = sourceModel.get(0).bool
             console.log("onSetAllCheckboxesLocal")

                for (var i=1; i<sourceModel.count;i++)
                {
                    if (firstValue!==sourceModel.get(i).bool)
                    {
                        console.log("found")
                        checkboxAll.checkedState = Qt.PartiallyChecked
                        break
                    }
                    else if(i===sourceModel.count-1)
                    {
                        checkboxAll.checkedState = firstValue ? Qt.Checked : Qt.Unchecked
                        selectedAll = !firstValue
                    }


                }

            }


        }

    }





           TableViewColumn {
        id: checkColumn
        //title: " "
        role: "check"
        movable: false
        resizable: false
        width: 20



        delegate: CheckBox {

                    id: checkBox
                    signal activated()

                    onClicked:{
                console.log("onClicked:" + styleData.row)
                        sourceModel.set(styleData.row, {"bool": checkBox.checked})
                            activated()
            setAllCheckboxes()}
                    Component.onCompleted: {
                window.supersignal.connect(activated)
                console.log("onCompleted:" + styleData.row)
                checked = sourceModel.get(styleData.row).bool}
                    onVisibleChanged: if (visible) checked = sourceModel.get(styleData.row).bool
                    onCheckedChanged: console.log("onCheckedChanged" + styleData.row)
                    onActivated: {
                checked = sourceModel.get(styleData.row).bool
                console.log("onActivated" + styleData.row)}


                    






                     }

    }

        TableViewColumn {
        id: checkBool
        role: "bool"
        width: 40
        visible: false
    }

    TableViewColumn {
    id: indexID
    role: "index"
    width: 40
        visible: false
}

        TableViewColumn {
            id: idColumn
            title: "Kundennummer"
            role: "idnumber"
            movable: false
            resizable: false

            width: 82




        }

        TableViewColumn {
            id: nameColumn
            title: "Kundenname"
            role: "name"
            movable: false
            resizable: false
            width: 200

        }

        TableViewColumn {
            id: zipColumn
            title: "PLZ"
            role: "zip"
            movable: false
            resizable: false
            width: 50
        }

        TableViewColumn {
            id: cityColumn
            title: "Ort"
            role: "city"
            movable: false
            resizable: false
            width: tableView.viewport.width / 6
        }

        TableViewColumn {
            id: countryColumn
            title: "Land"
            role: "country"
            movable: false
            resizable: false
            width: 40
        }

        TableViewColumn {
            id: streetColumn
            title: "Straße"
            role: "street"
            movable: false
            resizable: false
            width: tableView.viewport.width / 6

    }



        model: SortFilterProxyModel {
            id: proxyModel
            source: sourceModel.count > 0 ? sourceModel : null

            sortOrder: tableView.sortIndicatorOrder
            sortCaseSensitivity: Qt.CaseInsensitive
            sortRole: sourceModel.count > 0 ? tableView.getColumn(tableView.sortIndicatorColumn).role : ""

            filterString: "*" + searchBox.text + "*"
            filterSyntax: SortFilterProxyModel.Wildcard
            filterCaseSensitivity: Qt.CaseInsensitive
            //onSortOrderChanged: console.log("onSortOrderChanged")
            onSortRoleChanged:  {
            supersignal()
            //console.log("onSortRoleChanged")

        }
            onSortOrderChanged:
        {
            supersignal()
            //console.log("onSortOrderChanged")
            }

        }




         ListModel {
            id: sourceModel

       /*   ListElement {
                check: ""
                bool: false
                index: 0
                idnumber: "75864"
                name: "Herman Melville"
                zip: "67663"
                city: "Kaiserslautern"
                country: "USA"
                street: "2121 K Street"
            }*/

        }

        }

}

