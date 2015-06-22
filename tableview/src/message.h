/****************************************************************************
** Konica Minolta
** Artem Avtandilov
** 22/06/2015
****************************************************************************/

#ifndef MESSAGE
#define MESSAGE
#include <QMessageBox>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QXmlStreamWriter>
#include <QFileDialog>
#include <QDebug>
#include <QMessageBox>
#include <QApplication>


class Message : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap entry READ entry WRITE setEntry NOTIFY entryChanged)

public:

    QList<QVariantMap> All;
    QList<QVariantMap> EmptyAll;
    QVariantMap empty;
    void setEntry (const QVariantMap&);
    QVariantMap entry();

signals:
    void entryChanged();
private:
    QVariantMap m_entry;
       QString filename;
protected:
    void SaveXMLFile();
};
#endif // MESSAGE

