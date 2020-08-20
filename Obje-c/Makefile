THEOS = /Users/azozzalfiras/opt/theos

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = azinstaller
$(APPLICATION_NAME)_FILES = $(APPLICATION_NAME).mm
$(APPLICATION_NAME)_FRAMEWORKS = UIKit Foundation CoreGraphics
$(APPLICATION_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(APPLICATION_NAME)_LIBRARIES = MobileGestalt
$(APPLICATION_NAME)_CFLAGS = -fobjc-arc
$(APPLICATION_NAME)_LDFLAGS = -Wl,-segalign,4000
$(APPLICATION_NAME)_ARCHS = armv7 armv7s arm64 arm64e
export ARCHS = armv7 armv7s arm64 arm64e

include $(THEOS_MAKE_PATH)/application.mk

all::
