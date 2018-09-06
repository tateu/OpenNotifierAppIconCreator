export GO_EASY_ON_ME = 1

export ARCHS = arm64
export SDKVERSION = 8.4
export TARGET = iphone:clang:8.4

# export DEBUG = 1
ifeq ($(DEBUG),1)
	PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)+debug
else
	PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
endif

include $(THEOS)/makefiles/common.mk

TOOL_NAME = ONICreator
ONICreator_FILES = main.mm
ONICreator_FRAMEWORKS = UIKit MobileCoreServices
ONICreator_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tool.mk
