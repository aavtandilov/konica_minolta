/****************************************************************************
** Konica Minolta
** Artem Avtandilov
** 22/06/2015
** Defines class Message, that is used to communicate between C++ and QML codes
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
//Q_PROPERTY is used to integrate Qt code with QML: connect signals and return "entries".
//Each entry is the entry in database
public:

    QList<QVariantMap> All; //List of entries to export to XML
    QList<QVariantMap> EmptyAll; // Empty list of entries used to clean
    QVariantMap empty; //Empty QVariantMap = one empty entry
    void setEntry (const QVariantMap&); // loads new entry into All
    QVariantMap entry(); //initializes XML export and returns one entry (not used, but required)

signals:
    void entryChanged(); //notifies QML code if XML export was successful.
private:
    QVariantMap m_entry; //one entry
       QString filename; //filename of the exported XML file
protected:
    void SaveXMLFile(); // writes XML + moves the PDF
};
#endif // MESSAGE

