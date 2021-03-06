SK = $$_PRO_FILE_PWD_/../Sky

SK_CORE  = $$SK/src/SkCore/src
SK_GUI   = $$SK/src/SkGui/src
SK_MEDIA = $$SK/src/SkMedia/src

TARGET = HelloSky

!android:DESTDIR = $$_PRO_FILE_PWD_/bin

contains(QT_MAJOR_VERSION, 4) {
    QT += opengl declarative network xml xmlpatterns svg
} else {
    QT += opengl quick network xml xmlpatterns svg

    win32:QT += winextras

    unix:!macx:!android:QT += dbus x11extras

    android:QT += androidextras
}

# C++17
contains(QT_MAJOR_VERSION, 4) {
    QMAKE_CXXFLAGS += -std=c++1z
} else {
    CONFIG += c++1z
}

DEFINES += SK_CORE_LIBRARY SK_GUI_LIBRARY SK_MEDIA_LIBRARY

!win32-msvc*:!android:DEFINES += CAN_COMPILE_SSE2

contains(QT_MAJOR_VERSION, 4) {
    DEFINES += QT_4

    CONFIG(release, debug|release) {

        win32:DEFINES += SK_WIN_NATIVE
    }
} else {
    DEFINES += QT_LATEST #SK_SOFTWARE

    win32:DEFINES += SK_WIN_NATIVE
}

android {
    DEFINES += SK_MOBILE
} else {
    DEFINES += SK_DESKTOP
}

deploy|android {
    DEFINES += SK_DEPLOY

    RESOURCES = dist/HelloSky.qrc
}

!win32-msvc*:!android:QMAKE_CXXFLAGS += -msse

unix:QMAKE_LFLAGS += "-Wl,-rpath,'\$$ORIGIN'"

include(src/global/global.pri)
include(src/controllers/controllers.pri)
include(src/kernel/kernel.pri)
include(src/io/io.pri)
include(src/thread/thread.pri)
include(src/image/image.pri)
include(src/graphicsview/graphicsview.pri)
include(src/declarative/declarative.pri)
include(src/media/media.pri)
include(src/vlc/vlc.pri)

include(src/3rdparty/qtsingleapplication/qtsingleapplication.pri)

INCLUDEPATH += $$SK/include/SkCore \
               $$SK/include/SkGui \
               $$SK/include/SkMedia \
               $$SK/include \

contains(QT_MAJOR_VERSION, 5) {
    INCLUDEPATH += $$SK/include/Qt5 \
                   $$SK/include/Qt5/QtCore \
                   $$SK/include/Qt5/QtGui \
                   $$SK/include/Qt5/QtQml \
                   $$SK/include/Qt5/QtQuick
}

unix:!macx:!android:contains(QT_MAJOR_VERSION, 5) {
    INCLUDEPATH += $$SK/include/Qt5/QtDBus
}

unix:contains(QT_MAJOR_VERSION, 4) {
    INCLUDEPATH += $$SK/include/Qt4/QtCore \
                   $$SK/include/Qt4/QtGui \
                   $$SK/include/Qt4/QtDeclarative
}

win32:LIBS += -L$$SK/lib -llibvlc

# Windows dependency for ShellExecuteA and PostMessage
win32-msvc*:LIBS += shell32.lib User32.lib

macx:LIBS += -L$$SK/lib -lvlc

unix:!macx:!android:LIBS += -lvlc

android:LIBS += -L$$_PRO_FILE_PWD_/dist/android/libs/$$ANDROID_TARGET_ARCH -lvlc

unix:!macx:!android:contains(QT_MAJOR_VERSION, 4) {
    LIBS += -lX11
}

macx {
    PATH=$${DESTDIR}/$${TARGET}.app/Contents/MacOS

    QMAKE_POST_LINK = install_name_tool -change @rpath/libvlccore.dylib \
                      @loader_path/libvlccore.dylib $${DESTDIR}/libvlc.dylib;

    QMAKE_POST_LINK += install_name_tool -change @rpath/libvlc.dylib \
                       @loader_path/libvlc.dylib $$PATH/$${TARGET};

    QMAKE_POST_LINK += $${QMAKE_COPY} -r $${DESTDIR}/plugins $$PATH;

    QMAKE_POST_LINK += $${QMAKE_COPY} $${DESTDIR}/libvlc.dylib     $$PATH;
    QMAKE_POST_LINK += $${QMAKE_COPY} $${DESTDIR}/libvlccore.dylib $$PATH;
}

macx:ICON = dist/icon.icns

RC_FILE = dist/HelloSky.rc

OTHER_FILES += 3rdparty.sh \
               configure.sh \
               build.sh \
               deploy.sh \
               environment.sh \
               README.md \
               LICENSE.md \
               AUTHORS.md \
               .azure-pipelines.yml \
               content/generate.sh \
               content/Main.qml \
               dist/HelloSky.rc \
               dist/android/res/values/theme.xml \
               dist/android/res/drawable/splash.xml \

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$_PRO_FILE_PWD_/dist/android

    DISTFILES += $$ANDROID_PACKAGE_SOURCE_DIR/AndroidManifest.xml

    assets.path = $$ANDROID_PACKAGE_SOURCE_DIR/assets/videos

    assets.files = videos/sky.mp4

    INSTALLS += assets
}
