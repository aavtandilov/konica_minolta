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
    Q_PROPERTY(QVariantMap author READ author WRITE setAuthor NOTIFY authorChanged)

public:

    QList<QVariantMap> All;
    QList<QVariantMap> EmptyAll;
    QVariantMap empty;
    void setAuthor (const QVariantMap&);
    QVariantMap author();

signals:
    void authorChanged();
private:
    QVariantMap m_author;
       QString filename;
protected:
    void SaveXMLFile();
};
#endif // MESSAGE

