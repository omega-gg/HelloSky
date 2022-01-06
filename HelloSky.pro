SK = $$_PRO_FILE_PWD_/../Sky

SK_CORE  = $$SK/src/SkCore/src
SK_GUI   = $$SK/src/SkGui/src
SK_MEDIA = $$SK/src/SkMedia/src

TARGET = HelloSky

!android:DESTDIR = $$_PRO_FILE_PWD_/bin

contains(QT_MAJOR_VERSION, 4) {
    QT += opengl declarative network xml xmlpatterns svg

} else:contains(QT_MAJOR_VERSION, 5) {

    QT += opengl quick network xml xmlpatterns svg
} else {
    QT += quick network xml svg core5compat
}

greaterThan(QT_MAJOR_VERSION, 4) {
    unix:!macx:!android:QT += dbus
}

contains(QT_MAJOR_VERSION, 5) {
    win32:QT += winextras

    unix:!macx:!android:QT += x11extras

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
    CONFIG(release, debug|release) {

        win32:DEFINES += SK_WIN_NATIVE
    }
} else {
    win32:DEFINES += SK_WIN_NATIVE
}

deploy|android {
    DEFINES += SK_DEPLOY

    RESOURCES = dist/qrc/HelloSky.qrc
}

!win32-msvc*:!android:QMAKE_CXXFLAGS += -msse

unix:QMAKE_LFLAGS += "-Wl,-rpath,'\$$ORIGIN'"

include($$SK/src/Sk.pri)
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
               $$SK/include

unix:contains(QT_MAJOR_VERSION, 4) {
    INCLUDEPATH += $$SK/include/Qt4/QtCore \
                   $$SK/include/Qt4/QtGui \
                   $$SK/include/Qt4/QtDeclarative
}

greaterThan(QT_MAJOR_VERSION, 4) {
    INCLUDEPATH += $$SK/include/$$QTX \
                   $$SK/include/$$QTX/QtCore \
                   $$SK/include/$$QTX/QtGui \
                   $$SK/include/$$QTX/QtQml \
                   $$SK/include/$$QTX/QtQuick
}

unix:!macx:!android:greaterThan(QT_MAJOR_VERSION, 4) {
    INCLUDEPATH += $$SK/include/$$QTX/QtDBus
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
               .appveyor.yml \
               content/generate.sh \
               content/Main.qml \
               dist/HelloSky.rc \
               dist/script/start.sh \
               dist/android/qt5/AndroidManifest.xml \
               dist/android/qt6/AndroidManifest.xml \
               dist/android/res/values/theme.xml \
               dist/android/res/drawable/splash.xml \

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$_PRO_FILE_PWD_/dist/android

    DISTFILES += $$ANDROID_PACKAGE_SOURCE_DIR/AndroidManifest.xml

    assets.path = $$ANDROID_PACKAGE_SOURCE_DIR/assets/videos

    assets.files = videos/sky.mp4

    INSTALLS += assets
}
