/****************************************************************************
** Konica Minolta
** Artem Avtandilov
** 22/06/2015
** Core initialization unit. Implements QML initalization
****************************************************************************/

#include "qtquickcontrolsapplication.h"
#include "sortfilterproxymodel.h"
#include <QtQml/qqmlapplicationengine.h>
#include <QtGui/qsurfaceformat.h>
#include <QStringListModel>
#include <QList>
#include <QQuickView>
#include <QQmlContext>
#include <QQmlComponent>

#include <QtQml/qqml.h>
#include "connection.h" // SQL connection
#include "message.h" // Message class



int main(int argc, char *argv[])
{
    QtQuickControlsApplication app(argc, argv);

    if (!createConnection()) //attempts to connect to the DB
        return 1;

    if (QCoreApplication::arguments().contains(QLatin1String("--coreprofile"))) {
        QSurfaceFormat fmt;
        fmt.setVersion(4, 4);
        fmt.setProfile(QSurfaceFormat::CoreProfile);
        QSurfaceFormat::setDefaultFormat(fmt);
    }

    qmlRegisterType<SortFilterProxyModel>("SortFilter", 1, 0, "SortFilterProxyModel"); //registers the sorting model
    qmlRegisterType<Message>("Messager", 1, 0, "Message"); //registers the Message class
    QQmlApplicationEngine engine; //initilizing QML engine

    Message msg;
    engine.rootContext()->setContextProperty("msg", &msg);

    QQmlComponent component(&engine, QUrl("qrc:/main.qml")); //loads full QML

    QObject *object = component.create(); // start
    QSqlQuery query;
    query.exec("select * from vendor"); //loads DB
    QList<QVariantMap> mapCopy;
    int i=0; // DB entries counter
    while (query.next()) {
        QVariantMap newElement;  // QVariantMap will implicitly translates into JS-object
        newElement.insert("check", "check");
        newElement.insert("index", i);
        newElement.insert("bool", false); //Checked
        newElement.insert("idnumber", query.value(0).toString()); //Kundennummer
        newElement.insert("name", query.value(1).toString()); //Kundenname
        newElement.insert("zip", query.value(2).toString()); //PLZ
        newElement.insert("city", query.value(3).toString()); //Ort
        newElement.insert("country", query.value(4).toString()); // Land
        newElement.insert("street", query.value(5).toString()); //Straße

        QMetaObject::invokeMethod(object, "append", Q_ARG(QVariant, QVariant::fromValue(newElement))); //registers function to add elements to the list
        mapCopy.append(newElement);
        i++;
          }




    return app.exec();
}

