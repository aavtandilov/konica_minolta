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


ApplicationWindow {
    id: window
    visible: true
    title: "Konica Minolta Kunden Dateibank"

    FileDialog {
        id: fileDialog
        visible: false
        //modality: fileDialogModal.checked ? Qt.WindowModal : Qt.NonModal
        title: "Choose a file"
        nameFilters: [ "PDF-Datei (*.pdf)" ]
        selectedNameFilter: "All files (*)"
        onAccepted: {
            console.log("Accepted: " + fileDialog.fileUrls)


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
            text: "Select PDF"
            anchors.left: pic.right
            anchors.verticalCenter: parent.verticalCenter
            onClicked: fileDialog.open();
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

        anchors.fill: parent

        Layout.minimumWidth: 400
        Layout.minimumHeight: 240
        Layout.preferredWidth: 800
        Layout.preferredHeight: 600


           TableViewColumn {
        id: checkColumn
        //title: " "
        role: "check"
        movable: false
        resizable: false
        width: 20
        delegate: CheckBox {
                    id: checkBox
                     onCheckedChanged: {
                         //Here is where I want to call setData
                     }
                }
    }
        TableViewColumn {
            id: idColumn
            title: "Kundennummer"
            role: "idnumber"
            movable: false
            resizable: false
            width: tableView.viewport.width/6
        }

        TableViewColumn {
            id: nameColumn
            title: "Kundenname"
            role: "name"
            movable: false
            resizable: false
            width: tableView.viewport.width / 6
        }

        TableViewColumn {
            id: zipColumn
            title: "PLZ"
            role: "zip"
            movable: false
            resizable: false
            width: tableView.viewport.width / 6
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
            width: tableView.viewport.width / 6
        }

        TableViewColumn {
            id: streetColumn
            title: "Straße"
            role: "street"
            movable: false
            resizable: false
            width: tableView.viewport.width / 6
        }

        TableViewColumn {
            id: pdfColumn
            title: "PDF"
            role: "pdf"
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
        }



         ListModel {
            id: sourceModel

          ListElement {
                check: ""
                idnumber: "75864"
                name: "Herman Melville"
                zip: "67663"
                city: "Kaiserslautern"
                country: "USA"
                street: "2121 K Street"
            }
          /*  ListElement {
                title: "The Adventures of Tom Sawyer"
                author: "Mark Twain"
            }
            ListElement {
                title: "Cat’s Cradle"
                author: "Kurt Vonnegut"
            }
            ListElement {
                title: "Farenheit 451"
                author: "Ray Bradbury"
            }
            ListElement {
                title: "It"
                author: "Stephen King"
            }
            ListElement {
                title: "On the Road"
                author: "Jack Kerouac"
            }
            ListElement {
                title: "Of Mice and Men"
                author: "John Steinbeck"
            }
            ListElement {
                title: "Do Androids Dream of Electric Sheep?"
                author: "Philip K. Dick"
            }
            ListElement {
                title: "Uncle Tom’s Cabin"
                author: "Harriet Beecher Stowe"
            }
            ListElement {
                title: "The Call of the Wild"
                author: "Jack London"
            }
            ListElement {
                title: "The Old Man and the Sea"
                author: "Ernest Hemingway"
            }
            ListElement {
                title: "A Streetcar Named Desire"
                author: "Tennessee Williams"
            }
            ListElement {
                title: "Catch-22"
                author: "Joseph Heller"
            }
            ListElement {
                title: "One Flew Over the Cuckoo’s Nest"
                author: "Ken Kesey"
            }
            ListElement {
                title: "The Murders in the Rue Morgue"
                author: "Edgar Allan Poe"
            }
            ListElement {
                title: "Breakfast at Tiffany’s"
                author: "Truman Capote"
            }
            ListElement {
                title: "Death of a Salesman"
                author: "Arthur Miller"
            }
            ListElement {
                title: "Post Office"
                author: "Charles Bukowski"
            }
            ListElement {
                title: "Herbert West—Reanimator"
                author: "H. P. Lovecraft"
            }*/


        }

        }

}

