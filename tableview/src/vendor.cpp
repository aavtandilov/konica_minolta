#include "vendor.h"
#include <QSqlQueryModel>

Vendor::Vendor(QObject *parent) :
    QSqlQueryModel(parent)
{
    setQuery("select * from person");
    setHeaderData(0, Qt::Horizontal, QObject::tr("ID"));
    setHeaderData(1, Qt::Horizontal, QObject::tr("firstName"));
    setHeaderData(2, Qt::Horizontal, QObject::tr("lastName"));
}
