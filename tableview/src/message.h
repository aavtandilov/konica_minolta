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



    void setAuthor(const QVariantMap &a) {
        if (a != m_author) {
            m_author = a;
            All.push_back(m_author);
            qDebug() << "hallo";
            qDebug() <<  m_author;
            qDebug() << All;
 //           emit authorChanged();

        }
    }

    QVariantMap author() {
        if(All.size()==1)
        {qDebug() << " Nothing chosen"+ QString::number(All.size());
            QMessageBox::critical(0, qApp->tr("Nichts ausgewählt!"),
                qApp->tr("Bitte wählen Sie ein oder mehrere Datensätze aus,\n"
                         "um die zu exportieren"), QMessageBox::Ok);
        return empty;
}
        SaveXMLFile();
        if (filename.isEmpty())
        {
            qDebug() << "filename is empty";
            for (int i=1;i<All.size();i++)
            All.clear();
            All = EmptyAll;

                return empty; }//
        else emit authorChanged();
            qDebug() << "filename is NOT empty";
            All = EmptyAll;
            return m_author;
    }

    void SaveXMLFile()
    {

        filename = QFileDialog::getSaveFileName(0, QObject::tr("XML Export"), ".", QObject::tr("XML-Datei (*.xml)"));
        if (filename.isEmpty())
        {
            return;
        }
         QString cut= All[0].value("URL").toString().mid(8);

        qDebug() << "Cut extracted: " + cut;
        qDebug() << filename;

        QFile file(filename);
        file.open(QIODevice::WriteOnly);

        QXmlStreamWriter xmlWriter(&file);
        xmlWriter.setAutoFormatting(true);
        xmlWriter.writeStartDocument();

        xmlWriter.writeStartElement("KUNDEN");

        for (int i=1; i<All.size(); i++)
        {
            xmlWriter.writeStartElement("KUNDE");

            xmlWriter.writeTextElement("KUNDENNUMMER", All[i].value("idnumber").toString());
            xmlWriter.writeTextElement("KUNDENNAME", All[i].value("name").toString());
            xmlWriter.writeTextElement("PLZ", All[i].value("zip").toString());
            xmlWriter.writeTextElement("ORT", All[i].value("city").toString());
            xmlWriter.writeTextElement("LAND", All[i].value("country").toString());
            xmlWriter.writeTextElement("STRAßE", All[i].value("street").toString());
            xmlWriter.writeTextElement("PDF", All[0].value("URL").toString().mid(8));
            //xmlWriter.writeTextElement("QQ", CE.getName(1).toString());
            qDebug() << "All[1].value(name)";
            qDebug() << All[1].value("name");
            xmlWriter.writeEndElement(); //END KUNDE
        }

        xmlWriter.writeEndElement(); //END KUNDEN
            file.close();

            QString PDFnew=filename;
            PDFnew.chop(4);


            if(QFile::rename(cut, PDFnew+".pdf"))
                qDebug() << "renamed";
            else
            {
                qDebug() << "NOT renamed: " + cut + " to " + PDFnew+".pdf";
                int i=1;
                while(!(QFile::rename(cut, PDFnew+ "-" + QString::number(i) + ".pdf")))
                {
                    qDebug() << "NOT renamed: " + QString::number(i);
                    i++;
                    if (i>100)
                        break;
                }
                qDebug() << "renamed"  + QString::number(i);
                All.clear();
                qDebug() << All;
            }
    }


signals:
    void authorChanged();
    void allChanged();
private:
    QVariantMap m_author;
   // QVariantMap zapis;
    QString filename;
    //void SaveXMLFile(QString);
};
#endif // MESSAGE

