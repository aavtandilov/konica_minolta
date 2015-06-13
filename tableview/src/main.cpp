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
#include "connection.h"
#include "dataobject.h"



int main(int argc, char *argv[])
{
    QtQuickControlsApplication app(argc, argv);

    if (!createConnection())
        return 1;

    if (QCoreApplication::arguments().contains(QLatin1String("--coreprofile"))) {
        QSurfaceFormat fmt;
        fmt.setVersion(4, 4);
        fmt.setProfile(QSurfaceFormat::CoreProfile);
        QSurfaceFormat::setDefaultFormat(fmt);
    }

    qmlRegisterType<SortFilterProxyModel>("org.qtproject.example", 1, 0, "SortFilterProxyModel");
    QQmlApplicationEngine engine;

    QQmlComponent component(&engine, QUrl("qrc:/main.qml"));
    QObject *object = component.create();
    QSqlQuery query;
    query.exec("select * from vendor");


    while (query.next()) {
        QVariantMap newElement;  // QVariantMap will implicitly translates into JS-object
        newElement.insert("check", "check");
        newElement.insert("idnumber", query.value(0).toString());
        newElement.insert("name", query.value(1).toString());
        newElement.insert("zip", query.value(2).toString());
        newElement.insert("city", query.value(3).toString());
        newElement.insert("country", query.value(4).toString());
        newElement.insert("street", query.value(5).toString());

        QMetaObject::invokeMethod(object, "append", Q_ARG(QVariant, QVariant::fromValue(newElement)));




    //        qDebug() << name << salary;
    }
/*
    for (int i=0; i<20; i++)
    {
    QVariantMap newElement;  // QVariantMap will implicitly translates into JS-object
    newElement.insert("idnumber", "1000");
    newElement.insert("name", "Suzanne Collins");
    newElement.insert("zip", "12345");
    newElement.insert("city", "Зажопинск");
    newElement.insert("country", "RU");
    newElement.insert("street", "Proletarskaya");

    QMetaObject::invokeMethod(object, "append", Q_ARG(QVariant, QVariant::fromValue(newElement)));
    //delete object;
    }
*/







//    view.setResizeMode(QQuickView::SizeRootObjectToView);




  //  engine.rootContext()->setContextProperty("myModel", QVariant::fromValue(dataList));
  //engine.rootContext()->setContextProperty("extraColumn", QVariant::fromValue(dataList));
  //  engine.rootContext()->setContextProperty("sourceModelV", QVariant::fromValue(dataList));
//    engine.load(QUrl("qrc:/main.qml"));




    return app.exec();
}
