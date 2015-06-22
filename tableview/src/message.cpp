/****************************************************************************
** Konica Minolta
** Artem Avtandilov
** 22/06/2015
****************************************************************************/

#include "message.h"

void Message::setEntry(const QVariantMap &a) {
    if (a != m_entry) {
        m_entry = a;
        All.push_back(m_entry);
        qDebug() << "hallo";
        qDebug() <<  m_entry;
        qDebug() << All;
//           emit entryChanged();

    }
}

QVariantMap Message::entry() {
    if(All.size()==1)
    {qDebug() << " Nothing chosen"+ QString::number(All.size());
        QMessageBox::critical(0, qApp->tr("Nichts ausgewählt!"),
            qApp->tr("Bitte wählen Sie ein oder mehrere Datensätze aus,\n"
                     "um die zu exportieren"), QMessageBox::Ok);
    return empty;
}
    Message::SaveXMLFile();
    if (filename.isEmpty())
    {
        qDebug() << "filename is empty";
        for (int i=1;i<All.size();i++)
        All.clear();
        All = EmptyAll;

            return empty; }//
    else emit entryChanged();
        qDebug() << "filename is NOT empty";
        All = EmptyAll;
        return m_entry;
}

void Message::SaveXMLFile()
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

