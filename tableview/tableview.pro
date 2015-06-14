TEMPLATE = app
TARGET = tableview
QT += sql widgets core

RESOURCES += \
    tableview.qrc

OTHER_FILES += \
    main.qml

include(src/src.pri)
include(../shared/shared.pri)
