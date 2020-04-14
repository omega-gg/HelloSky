SK = $$_PRO_FILE_PWD_/../Sky

SK_CORE = $$SK/src/SkCore/src
SK_GUI  = $$SK/src/SkGui/src

TARGET = HelloSky

DESTDIR = $$_PRO_FILE_PWD_/bin

contains(QT_MAJOR_VERSION, 4) {
    QT += opengl declarative network xml xmlpatterns svg
} else {
    QT += opengl quick network xml xmlpatterns svg
}

contains(QT_MAJOR_VERSION, 5) {
    win32:QT += winextras

    unix:!macx:!android:QT += x11extras
}

DEFINES += SK_CORE_LIBRARY SK_GUI_LIBRARY

contains(QT_MAJOR_VERSION, 4) {
    DEFINES += QT_4

    CONFIG(release, debug|release) {

        win32:DEFINES += SK_WIN_NATIVE
    }
} else {
    DEFINES += QT_LATEST #SK_SOFTWARE

    win32:DEFINES += SK_WIN_NATIVE
}

QMAKE_CXXFLAGS += -std=c++11

unix:QMAKE_LFLAGS += "-Wl,-rpath,'\$$ORIGIN'"

include(src/global/global.pri)
include(src/controllers/controllers.pri)
include(src/kernel/kernel.pri)
include(src/io/io.pri)
include(src/thread/thread.pri)
include(src/image/image.pri)
include(src/graphicsview/graphicsview.pri)
include(src/declarative/declarative.pri)
include(src/models/models.pri)
include(src/media/media.pri)

include(src/3rdparty/qtsingleapplication/qtsingleapplication.pri)

INCLUDEPATH += $$SK/include/SkCore \
               $$SK/include/SkGui \

contains(QT_MAJOR_VERSION, 5) {
    INCLUDEPATH += $$SK/include/Qt5 \
                   $$SK/include/Qt5/QtCore \
                   $$SK/include/Qt5/QtGui \
                   $$SK/include/Qt5/QtQml \
                   $$SK/include/Qt5/QtQuick
}

unix:contains(QT_MAJOR_VERSION, 4) {
    INCLUDEPATH += $$SK/include/Qt4/QtCore \
                   $$SK/include/Qt4/QtGui \
                   $$SK/include/Qt4/QtDeclarative
}

unix:!macx:!android:contains(QT_MAJOR_VERSION, 4) {
    LIBS += -lX11
}

RESOURCES = dist/HelloSky.qrc

OTHER_FILES += 3rdparty.sh \
               configure.sh \
               build.sh \
               deploy.sh \
               README.md \
               LICENSE.md \
               AUTHORS.md \
               .azure-pipelines.yml \
               content/Main.qml \
               dist/qrc.sh \
