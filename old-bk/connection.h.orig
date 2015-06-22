/****************************************************************************
** Konica Minolta
** Artem Avtandilov
** 22/06/2015
** This is a header file implementing connection to the MySQL Database.
** It initializes the driver, checks the connection for errors, and, if needed,
** produces the error message.
****************************************************************************/

#ifndef CONNECTION_H
#define CONNECTION_H

#include <QMessageBox>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QXmlStreamWriter>
#include <QFileDialog>
#include <QDebug>


//! [0]
static bool createConnection()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL"); //driver initialized


    db.setHostName("127.0.0.1"); //local host
       db.setDatabaseName("konica_minolta"); //DB name
       db.setUserName("root");
       db.setPassword("admin");

    if (!db.open()) {
        QMessageBox::critical(0, qApp->tr("Datenbank ist nicht verfügbar!"),
            qApp->tr("Das Programm ist nicht in der Lage, \n"
                     "eine Datenbankverbindung herzustellen"), QMessageBox::Ok);
        return false;
    }

     return true;
}

//! [0]

#endif
