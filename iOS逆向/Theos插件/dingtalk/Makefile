export THEOS_DEVICE_IP=192.168.1.160
export THEOS_DEVICE_PORT=22

TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DingTalk

DingTalk_FILES = Tweak.x
DingTalk_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
