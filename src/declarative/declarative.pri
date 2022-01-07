# Declarative module

HEADERS += $$SK_GUI/declarative/WDeclarativeApplication.h \
           $$SK_GUI/declarative/WDeclarativeItem.h \
           $$SK_GUI/declarative/WDeclarativeItem_p.h \
           $$SK_GUI/declarative/WDeclarativeMouseArea.h \
           $$SK_GUI/declarative/WDeclarativeMouseArea_p.h \
           $$SK_GUI/declarative/WDeclarativeBorders.h \
           $$SK_GUI/declarative/WDeclarativeImageBase.h \
           $$SK_GUI/declarative/WDeclarativeImageBase_p.h \
           $$SK_GUI/declarative/WDeclarativeImage.h \
           $$SK_GUI/declarative/WDeclarativeImage_p.h \
           $$SK_GUI/declarative/WDeclarativeImageSvg.h \
           $$SK_GUI/declarative/WDeclarativeImageSvg_p.h \
           $$SK_GUI/declarative/WDeclarativePlayer.h \
           $$SK_GUI/declarative/WDeclarativePlayer_p.h \

greaterThan(QT_MAJOR_VERSION, 4): HEADERS += $$SK_GUI/declarative/WDeclarativeTexture.h \
                                             $$SK_GUI/declarative/WDeclarativeTexture_p.h \
                                             $$SK_GUI/declarative/WDeclarativeItemPaint.h \
                                             $$SK_GUI/declarative/WDeclarativeItemPaint_p.h \

SOURCES += $$SK_GUI/declarative/WDeclarativeApplication.cpp \
           $$SK_GUI/declarative/WDeclarativeItem.cpp \
           $$SK_GUI/declarative/WDeclarativeMouseArea.cpp \
           $$SK_GUI/declarative/WDeclarativeBorders.cpp \
           $$SK_GUI/declarative/WDeclarativeImageBase.cpp \
           $$SK_GUI/declarative/WDeclarativeImage.cpp \
           $$SK_GUI/declarative/WDeclarativeImageSvg.cpp \
           $$SK_GUI/declarative/WDeclarativePlayer.cpp \

greaterThan(QT_MAJOR_VERSION, 4): SOURCES += $$SK_GUI/declarative/WDeclarativeTexture.cpp \
                                             $$SK_GUI/declarative/WDeclarativeItemPaint.cpp \
