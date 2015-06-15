#ifndef CHECKEDENTRIES
#define CHECKEDENTRIES
#include <QMessageBox>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QXmlStreamWriter>
#include <QFileDialog>
#include <QDebug>

class CheckedEntries : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap author READ author WRITE setAuthor NOTIFY authorChanged)
public:
    QList<QVariantMap> All;
    void setAuthor(const QVariantMap &a) {
        if (a != m_author) {
            m_author = a;
            emit authorChanged();
         All.push_back(m_author);
         qDebug() << "hallo";
         qDebug() <<  m_author;
         qDebug() << All;
        }
    }

    QVariant getName(int i)
    {
        return All[i].value("name");
    }

    QVariantMap author() {

        if (filename.isEmpty())
            return m_author;
        else return m_author;
    }



signals:
    void authorChanged();

private:
QVariantMap m_author;
    QString filename;

};
#endif // CHECKEDENTRIES

