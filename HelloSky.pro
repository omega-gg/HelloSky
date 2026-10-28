SK = $$_PRO_FILE_PWD_/../Sky

SK_CORE    = $$SK/src/SkCore/src
SK_GUI     = $$SK/src/SkGui/src
SK_BACKEND = $$SK/src/SkBackend/src
SK_MEDIA   = $$SK/src/SkMedia/src

TARGET = HelloSky

!android:DESTDIR = $$_PRO_FILE_PWD_/bin

contains(QT_MAJOR_VERSION, 4) {
    QT += opengl declarative network script xml xmlpatterns svg

} else:contains(QT_MAJOR_VERSION, 5) {

    QT += opengl quick network xml xmlpatterns svg

    win32:QT += winextras

    unix:!macx:!ios:!android:QT += x11extras

    android:QT += androidextras
} else {
    QT += quick network xml svg core5compat

    #----------------------------------------------------------------------------------------------
    # NOTE Qt6.3: We need the widgets for QApplication and QFileDialog(s).

    win32:QT += widgets

    macx:QT += widgets

    unix:!android:QT += widgets
}

greaterThan(QT_MAJOR_VERSION, 4) {
    unix:!macx:!ios:!android:QT += dbus
}

# C++17
contains(QT_MAJOR_VERSION, 4) {
    QMAKE_CXXFLAGS += -std=c++1z
} else {
    CONFIG += c++1z
}

DEFINES += QUAZIP_BUILD \
           SK_CORE_LIBRARY SK_GUI_LIBRARY SK_BACKEND_LIBRARY SK_MEDIA_LIBRARY

win32|macx:contains(QT_MAJOR_VERSION, 6) {
    DEFINES += QWK_CORE_LIBRARY QWK_QUICK_LIBRARY
}

!win32-msvc*:!ios:!android:DEFINES += CAN_COMPILE_SSE2

#DEFINES += SK_SOFTWARE

win32|macx:contains(QT_MAJOR_VERSION, 6) {
    DEFINES += SK_WINDOW_NATIVE
}

deploy|ios|android {
    DEFINES += SK_DEPLOY

    RESOURCES = dist/qrc/HelloSky.qrc
}

!win32-msvc*:!ios:!android:QMAKE_CXXFLAGS += -msse

# NOTE: This is required to load frameworks in the lib folder.
ios:QMAKE_LFLAGS += -F$$SK/lib

unix:QMAKE_LFLAGS += "-Wl,-rpath,'\$$ORIGIN'"

include($$SK/src/Sk.pri)
include(src/global/global.pri)
include(src/controllers/controllers.pri)
include(src/kernel/kernel.pri)
include(src/io/io.pri)
include(src/thread/thread.pri)
include(src/network/network.pri)
include(src/image/image.pri)
include(src/graphicsview/graphicsview.pri)
include(src/declarative/declarative.pri)
include(src/media/media.pri)

contains(DEFINES, SK_VLC) {
    include(src/vlc/vlc.pri)
} else {
    include(src/ffmpeg/ffmpeg.pri)
}

include(src/3rdparty/qtsingleapplication/qtsingleapplication.pri)
include(src/3rdparty/zlib/zlib.pri)
include(src/3rdparty/quazip/quazip.pri)

win32|macx:contains(QT_MAJOR_VERSION, 6) {
    include(src/3rdparty/qwindowkit/qwindowkit.pri)
}

INCLUDEPATH += $$SK/include/SkCore \
               $$SK/include/SkGui \
               $$SK/include/SkBackend \
               $$SK/include/SkMedia \
               $$SK/include

# NOTE: FFmpeg plays its audio through Qt Multimedia.
!contains(DEFINES, SK_VLC) {
    QT += multimedia

    INCLUDEPATH += $$SK/include/ffmpeg
}

unix:contains(QT_MAJOR_VERSION, 4) {
    INCLUDEPATH += $$SK/include/$$QTX \
                   $$SK/include/$$QTX/QtCore \
                   $$SK/include/$$QTX/QtGui \
                   $$SK/include/$$QTX/QtDeclarative
}

greaterThan(QT_MAJOR_VERSION, 4) {
    INCLUDEPATH += $$SK/include/$$QTX \
                   $$SK/include/$$QTX/QtCore \
                   $$SK/include/$$QTX/QtGui \
                   $$SK/include/$$QTX/QtQml \
                   $$SK/include/$$QTX/QtQuick
}

win32|macx:contains(QT_MAJOR_VERSION, 6) {
    INCLUDEPATH += $$SK/include/SkGui/QWKCore \
                   $$SK/include/SkGui/QWKCore/private \
                   $$SK/include/SkGui/QWKQuick \
                   $$SK/include/SkGui/QWKQuick/private
}

unix:!macx:!ios:!android:greaterThan(QT_MAJOR_VERSION, 4) {
    INCLUDEPATH += $$SK/include/$$QTX/QtDBus
}

contains(DEFINES, SK_VLC) {

    ENGINE = -lvlc

    win32:ENGINE = -llibvlc

    vlc4 {
        ios:LIBS += -framework VLCKit
    } else {
        ios:LIBS += -framework MobileVLCKit
    }
} else {
    # NOTE: Our FFmpeg libraries are prefixed with sk beside Qt Multimedia's FFmpeg.

    ENGINE = -lsk-avformat \
             -lsk-avcodec \
             -lsk-avfilter \
             -lsk-avutil \
             -lsk-swscale \
             -lsk-swresample

    ios:LIBS += -framework sk-avformat \
                -framework sk-avcodec \
                -framework sk-avfilter \
                -framework sk-avutil \
                -framework sk-swscale \
                -framework sk-swresample
}

win32:LIBS += -L$$SK/lib $$ENGINE

# Windows dependency for ShellExecuteA and PostMessage
win32-msvc*:LIBS += shell32.lib User32.lib

# Windows dependency for qwindowkit
win32:LIBS += -lgdi32

unix:!ios:!android:LIBS += -L$$SK/lib $$ENGINE

# NOTE iOS: MediaPlayer is required for MP* classes.
ios:LIBS += -framework MediaPlayer

android:LIBS += -L$$ANDROID_LIB $$ENGINE

unix:!macx:!ios:!android:contains(QT_MAJOR_VERSION, 4) {
    LIBS += -lX11
}

macx {
    PATH=$${DESTDIR}/$${TARGET}.app/Contents/MacOS

contains(DEFINES, SK_VLC) {
    QMAKE_POST_LINK = install_name_tool -change @rpath/libvlccore.dylib \
                      @loader_path/libvlccore.dylib $${DESTDIR}/libvlc.dylib;

    QMAKE_POST_LINK += install_name_tool -change @rpath/libvlc.dylib \
                       @loader_path/libvlc.dylib $$PATH/$${TARGET};

    QMAKE_POST_LINK += $${QMAKE_COPY} -r $${DESTDIR}/plugins $$PATH;

    QMAKE_POST_LINK += $${QMAKE_COPY} $${DESTDIR}/libvlc.dylib     $$PATH;
    QMAKE_POST_LINK += $${QMAKE_COPY} $${DESTDIR}/libvlccore.dylib $$PATH;
} else {
    QMAKE_POST_LINK = install_name_tool -add_rpath @loader_path $$PATH/$${TARGET};

    QMAKE_POST_LINK += $${QMAKE_COPY} -P $${DESTDIR}/libsk-* $$PATH;
}
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
               dist/iOS/Info.plist \
               dist/iOS/LaunchScreen.storyboard \
               dist/iOS/Images.xcassets/Contents.json \
               dist/iOS/Images.xcassets/AppIcon.appiconset/Contents.json \
               dist/android/res/values/theme.xml \
               dist/android/res/drawable/splash.xml \
               dist/android/qt5/AndroidManifest.xml \
               dist/android/qt5/build.gradle \
               dist/android/qt5/gradle/wrapper/gradle-wrapper.properties \
               dist/android/qt6/AndroidManifest.xml \
               dist/android/qt6/build.gradle \
               dist/android/qt6/gradle/wrapper/gradle-wrapper.properties \

ios {
    # NOTE iOS: This is required for VLCKit.
    Q_ENABLE_BITCODE.name = ENABLE_BITCODE
    Q_ENABLE_BITCODE.value = NO

    QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE

    QMAKE_INFO_PLIST = $$_PRO_FILE_PWD_/dist/iOS/Info.plist

    icons.files=$$_PRO_FILE_PWD_/dist/iOS/Images.xcassets

    # NOTE iOS: We need to specify this in Info.plist.
    launch.files=$$_PRO_FILE_PWD_/dist/iOS/Launch.storyboard

contains(DEFINES, SK_VLC) {
    vlc4 {
        framework.files = $$SK/lib/VLCKit.framework
    } else {
        framework.files = $$SK/lib/MobileVLCKit.framework
    }
} else {
    framework.files = $$SK/lib/sk-avformat.framework \
                      $$SK/lib/sk-avcodec.framework \
                      $$SK/lib/sk-avfilter.framework \
                      $$SK/lib/sk-avutil.framework \
                      $$SK/lib/sk-swscale.framework \
                      $$SK/lib/sk-swresample.framework
}

    framework.path = Frameworks

    videos.files = $$_PRO_FILE_PWD_/content/videos

    QMAKE_BUNDLE_DATA += icons launch framework videos

} android {
    ANDROID_PACKAGE_SOURCE_DIR = $$ANDROID_PACKAGE

    DISTFILES += $$ANDROID_PACKAGE/AndroidManifest.xml \
                 $$ANDROID_PACKAGE/build.gradle \
                 $$ANDROID_PACKAGE/gradle/wrapper/gradle-wrapper.properties \
                 $$ANDROID_PACKAGE/libs/classes.jar
}
