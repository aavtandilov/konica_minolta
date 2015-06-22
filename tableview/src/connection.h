/****************************************************************************
** Konica Minolta
** Artem Avtandilov
** 22/06/2015
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
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");


    db.setHostName("127.0.0.1");
       db.setDatabaseName("konica_minolta");
       db.setUserName("root");
       db.setPassword("admin");

    if (!db.open()) {
        QMessageBox::critical(0, qApp->tr("Datenbank ist nicht verfügbar!"),
            qApp->tr("Das Program ist nicht in der Lage, \n"
                     "eine Datenbankverbindung zu erstellen"), QMessageBox::Ok);
        return false;
    }

     return true;
}





//! [0]

#endif
