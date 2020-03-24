SK = $$_PRO_FILE_PWD_/../Sky

SK_CORE = $$SK/src/SkCore/src

TARGET = HelloSky

DESTDIR = $$_PRO_FILE_PWD_/bin

DEFINES += SK_CORE_LIBRARY

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

INCLUDEPATH += $$SK/include/SkCore \

unix:!macx:!android:contains(QT_MAJOR_VERSION, 4) {
    LIBS += -lX11
}

macx {
    PATH=$${DESTDIR}/$${TARGET}.app/Contents/MacOS

    QMAKE_POST_LINK = install_name_tool -change @rpath/libvlccore.dylib \
                      @loader_path/libvlccore.dylib $${DESTDIR}/libvlc.dylib;
}

OTHER_FILES += README.md \
               LICENSE.md \
               AUTHORS.md \
               .azure-pipelines.yml \
