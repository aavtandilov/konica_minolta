/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import org.qtproject.example 1.0
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

     onAuthorChanged:    {
         console.log("Author Changed")
         pdfButton.enabled = true
         xmlButton.enabled = false
         }
     onXmlActivated: {
         //author = { URL: fileDialog.fileUrls.toString()}
         author = { URL: fileDialog.fileUrls.toString()}  // invokes Message::setAuthor()
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
             author= schicken
             }
         }



         console.log (author) //invokes XML open dialog




     }
    //Component.onCompleted: xmlButton.clicked.connect(xmlActivated())//message.xmlActivated.connect(clicked())

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
          //  visible: false
            width: 82
        //Component.onCompleted: resizeToContents()



        }

        TableViewColumn {
            id: nameColumn
            title: "Kundenname"
            role: "name"
            movable: false
            resizable: false
            width: 200
        //Component.onCompleted: nameColumn.resizeToContents()
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

            sortOrder: /*tableView.getColumn(1)*/tableView.sortIndicatorOrder
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


     //   Component.onCompleted: sourceModel.remove(0)//console.log("ListModel initiate")
        }

        }

}

