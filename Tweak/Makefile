ARCHS = arm64 arm64e
TARGET = iphone:clang::13.5

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Lobelias
$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit AudioToolbox
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = MediaRemote
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei
$(TWEAK_NAME)_LIBRARIES = sparkcolourpicker kitten

include $(THEOS_MAKE_PATH)/tweak.mk
