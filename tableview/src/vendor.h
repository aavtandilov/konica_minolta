#ifndef VENDOR
#define VENDOR
#include <QSqlQueryModel>
#include <QObject>
class Vendor : public QSqlQueryModel
{
    Q_OBJECT

public:
    Vendor(QObject *parent = 0);

    //QVariant data(const QModelIndex &item, int role) const Q_DECL_OVERRIDE;
};

#endif // VENDOR

