SK = $$_PRO_FILE_PWD_/../Sky

SK_CORE = $$SK/src/SkCore/src
SK_GUI  = $$SK/src/SkGui/src

TARGET = HelloSky

DESTDIR = $$_PRO_FILE_PWD_/bin

contains(QT_MAJOR_VERSION, 4) {
    QT += opengl declarative network xml xmlpatterns
} else {
    QT += opengl qml network xml xmlpatterns
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

include(src/3rdparty/qtsingleapplication/qtsingleapplication.pri)

INCLUDEPATH += $$SK/include/SkCore \
               $$SK/include/SkGui \

unix:!macx:!android:contains(QT_MAJOR_VERSION, 4) {
    LIBS += -lX11
}

OTHER_FILES += README.md \
               LICENSE.md \
               AUTHORS.md \
               .azure-pipelines.yml \
