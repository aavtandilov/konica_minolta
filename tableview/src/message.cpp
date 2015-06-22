/****************************************************************************
** Konica Minolta
** Artem Avtandilov
** 22/06/2015
** Implements function from Message classs
****************************************************************************/

#include "message.h"

void Message::setEntry(const QVariantMap &a) //adds one entry to All
{
    if (a != m_entry) {
        m_entry = a;
        All.push_back(m_entry);
        qDebug() << "hallo";
        qDebug() <<  m_entry;
        qDebug() << All;


    }
}

QVariantMap Message::entry() //initializes the XML export in full
{
    if(All.size()==1) // if there is no entries selected, one entry is the PDF address
    {
        qDebug() << " Nothing chosen"+ QString::number(All.size());
        QMessageBox::critical(0, qApp->tr("Nichts ausgewählt!"),
            qApp->tr("Bitte wählen Sie einen oder mehrere Datensätze aus,\n"
                     "um diese zu exportieren"), QMessageBox::Ok);
    return empty;
}
    Message::SaveXMLFile(); // invokes XML writing
    if (filename.isEmpty()) // if user has not selected any file
    {
        qDebug() << "filename is empty";
        for (int i=1;i<All.size();i++)
        All.clear(); // clears All
        All = EmptyAll; // complete clear

            return empty; }// returns empty entry
    else emit entryChanged(); // if the writing was successful, reactivate PDF button, block XML button
        qDebug() << "filename is NOT empty";
        All = EmptyAll; //clears All for the next export
        return m_entry; // returns one entry
}

void Message::SaveXMLFile()
{

    filename = QFileDialog::getSaveFileName(0, QObject::tr("XML Export"), ".", QObject::tr("XML-Datei (*.xml)"));
    if (filename.isEmpty()) //if user has not selected anything
      return;

     QString cut= All[0].value("URL").toString().mid(8); //cuts the unused file://///

    qDebug() << "Cut extracted: " + cut;
    qDebug() << filename;

    QFile file(filename);
    file.open(QIODevice::WriteOnly); //initializes writing

    QXmlStreamWriter xmlWriter(&file);
    xmlWriter.setAutoFormatting(true);
    xmlWriter.writeStartDocument(); //start xml document

    xmlWriter.writeStartElement("KUNDEN"); //main open tag

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
        xmlWriter.writeEndElement(); //END KUNDE
    }

    xmlWriter.writeEndElement(); //END KUNDEN
        file.close();

        QString PDFnew=filename;
        PDFnew.chop(4); //loads destination + same filename


        if(QFile::rename(cut, PDFnew+".pdf")) //renames
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

